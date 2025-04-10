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

                Math.Abs(u.Ranking - request.Ranking) <= 50);

            if (existing != null)
            {
                WaitingUsers.Remove(existing);

                // 👉 Ghép trận
                var matchId = Guid.NewGuid().ToString();

                await Clients.Client(Context.ConnectionId).SendAsync("MatchFound", new { MatchId = matchId, Rival = existing });
                var targetConnection = existing.ConnectionId;
                await Clients.Client(targetConnection).SendAsync("MatchFound", new { MatchId = matchId, Rival = request });

                // 👉 Lưu vào DB ở đây nếu cần
                //    using (var scope = _serviceProvider.CreateScope())
                //        try
                //        {
                //            var matchRepo = scope.ServiceProvider.GetRequiredService<IMatchesRepository>();
                //            var teamRepo = scope.ServiceProvider.GetRequiredService<ITeamRepository>();
                //            var db = scope.ServiceProvider.GetRequiredService<PickerBallDbcontext>();

                //            // Giả lập tạo 2 team (bạn cần xử lý chuẩn theo project của bạn)
                //            var team1 = new Team { CreatedAt = DateTime.UtcNow };
                //            var team2 = new Team { CreatedAt = DateTime.UtcNow };
                //        }
                //}
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
