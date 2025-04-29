using Database.DTO.Request;
using Database.Model.Dbcontext;
using Database.Model;
using Microsoft.AspNetCore.SignalR;
using Microsoft.Extensions.DependencyInjection;
using Repository.Repository.Interface;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Services.Services;
using System.Net;
using Services.Services.Interface;

namespace Services.Real_Time
{
    public class MatchHub : Hub
    {
        public static List<MatchRequest> WaitingUsers = new();
        private readonly IServiceProvider _serviceProvider;

        public MatchHub(IServiceProvider serviceProvider)
        {
            _serviceProvider = serviceProvider;
        }


        public async Task FindMatch(MatchRequest request)
        {
            var existing = WaitingUsers.FirstOrDefault(u =>
                u.UserId != request.UserId &&
                u.Gender == request.Gender &&
                u.City == request.City &&
                u.MatchFormat == request.MatchFormat &&

                Math.Abs(u.Ranking - request.Ranking) <= 50);

            if (existing != null)
            {
                WaitingUsers.Remove(existing);

                // 👉 Ghép trận
                //var matchId = Guid.NewGuid().ToString();

                await Clients.Client(Context.ConnectionId).SendAsync("MatchFound", new { Rival = existing });
                var targetConnection = existing.ConnectionId;
                await Clients.Client(targetConnection).SendAsync("MatchFound", new { Rival = request });

                // 👉 Lưu vào DB ở đây nếu cần
                using (var scope = _serviceProvider.CreateScope())
                    try
                    {
                        var matchRepo = scope.ServiceProvider.GetRequiredService<IMatchesRepository>();
                        var matchService = scope.ServiceProvider.GetRequiredService<IMatchService>();
                        var teamRepo = scope.ServiceProvider.GetRequiredService<ITeamRepository>();
                        var db = scope.ServiceProvider.GetRequiredService<PickerBallDbcontext>();

                        // Giả lập tạo 2 team (bạn cần xử lý chuẩn theo project của bạn)
                        var createRoomDto = new CreateRoomDTO
                        {
                            Title = $"Match {DateTime.Now:yyyyMMddHHmmss}",
                            Description = "Auto matched via real-time",
                            MatchDate = DateTime.Now.AddDays(1), // Giả định trận đấu bắt đầu sau 5 phút
                            VenueId = null, // Nếu có thể chọn sân thì gán
                            Status = MatchStatus.Scheduled,
                            MatchCategory = MatchCategory.Competitive,
                            MatchFormat = (MatchFormat)request.MatchFormat,
                            WinScore = WinScore.Eleven,
                            IsPublic = false,
                            RefereeId = null, // nếu chưa có trọng tài
                            TournamentId = null, // nếu không nằm trong giải nào
                            RoomOnwer = request.UserId, // Người vừa request sẽ là chủ phòng
                            Player1Id = request.UserId,
                            Player2Id = existing.UserId
                        };

                        var createRoomResult = await matchService.CreateRoomWithTeamsAsync(createRoomDto);

                        if (createRoomResult.statusCode == HttpStatusCode.OK)
                        {
                            // Bạn có thể bắn thêm event cho 2 client biết roomId nếu cần
                            await Clients.Client(Context.ConnectionId).SendAsync("RoomCreated", createRoomResult.Data.Id);
                            await Clients.Client(targetConnection).SendAsync("RoomCreated", createRoomResult.Data.Id);
                        }
                        else
                        {
                            // Nếu lỗi, thông báo cho cả 2 client
                            await Clients.Client(Context.ConnectionId).SendAsync("RoomCreationFailed", createRoomResult.Message);
                            await Clients.Client(targetConnection).SendAsync("RoomCreationFailed", createRoomResult.Message);
                        }

                    }catch(Exception ex)
                    {
                        throw new Exception(ex.Message);
                    }
            }
            else
            {
                request.ConnectionId = Context.ConnectionId;
                WaitingUsers.Add(request);
                await Clients.Client(Context.ConnectionId).SendAsync("WaitingForMatch");
            }
        }
        public override Task OnDisconnectedAsync(Exception? exception)
        {
            var user = WaitingUsers.FirstOrDefault(x => x.ConnectionId == Context.ConnectionId);
            if (user != null)
                WaitingUsers.Remove(user);
            return base.OnDisconnectedAsync(exception);
        }

    }
}
