using AutoMapper;
using Database.DTO.Response;
using Database.Model;
using Microsoft.EntityFrameworkCore;
using Repository.Repository.Interfeace;
using Services.Services.Interface;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;

namespace Services.Services
{
    public class NotificationServices : INotificationServices
    {
        private readonly INotificationRepository _notificationRepository;
        private readonly IUserRepository _userRepository;
        private readonly IMapper _mapper;

        public NotificationServices(INotificationRepository notificationRepository, IUserRepository userRepository, IMapper mapper)
        {
            _notificationRepository = notificationRepository;
            _userRepository = userRepository;
            _mapper = mapper;
        }

        public async Task<StatusResponse<int>> CountNotiOfUser(int userId)
        {
            var response = new StatusResponse<int>();
            try
            {
                var data = await _notificationRepository.Get().Where(x => x.UserId == userId).ToListAsync();
                var result = data.Count();
                response.Data = result;
                response.statusCode = HttpStatusCode.OK;
                response.Message = "Count all Notification of User Succesfully";
            }
            catch (Exception ex)
            {
                response.statusCode = HttpStatusCode.InternalServerError;
                response.Message = ex.Message;
            }
            return response;
        }

        public Task<StatusResponse<bool>> DeleteAllNotification(int userId)
        {
            throw new NotImplementedException();
        }

        public Task<StatusResponse<bool>> DeleteNotification(int notificationId)
        {
            throw new NotImplementedException();
        }

        public async Task<StatusResponse<List<NotificationResponseDTO>>> GetNotificationByUserId(int userId)
        {
            var response = new StatusResponse<List<NotificationResponseDTO>>();
            try
            {
                var notifications = await _notificationRepository.Get()
                    .Where(n => n.UserId == userId && n.IsRead == false)
                    .OrderByDescending(n => n.CreatedAt)
                    .ToListAsync();

                var result = new List<NotificationResponseDTO>();

                foreach (var item in notifications)
                {
                    var dto = new NotificationResponseDTO
                    {
                        Id = item.Id,
                        Message = item.Message,
                        CreatedAt = item.CreatedAt,
                        IsRead = item.IsRead,
                        Type = item.Type,
                        ReferenceId = item.ReferenceId,
                        BonusId = item.BonusId
                    };

                    switch (item.Type)
                    {
                        case NotificationType.FriendRequest:
                            dto.RedirectUrl = $"https://pickbleballcapston-a4eagpasc9fbeeb8.eastasia-01.azurewebsites.net/api/Friend/AcceptFriend";
                            dto.ExtraInfo = "Xem lời mời kết bạn";
                            break;

                        case NotificationType.MatchRequest:
                            dto.RedirectUrl = $"https://pickbleballcapston-a4eagpasc9fbeeb8.eastasia-01.azurewebsites.net/api/MatcheSendRequest/GetByReceviedId/{item.ReferenceId}";
                            dto.ExtraInfo = "Xem lời mời ghép trận";
                            break;

                        case NotificationType.AccpetTournamentTeamRequest:
                            dto.RedirectUrl = $"https://pickbleballcapston-a4eagpasc9fbeeb8.eastasia-01.azurewebsites.net/api/TournamentTeamRequest/GetTeamRequestByReceiverUser/{item.ReferenceId}";
                            dto.ExtraInfo = "Xem lời mời tham gia đội";
                            break;
                        case NotificationType.TournamentTeamRequest:
                            dto.RedirectUrl = $"https://pickbleballcapston-a4eagpasc9fbeeb8.eastasia-01.azurewebsites.net/api/Tourament/GetTournamentById/{item.ReferenceId}";
                            dto.ExtraInfo = "Xem lời mời tham gia đội";
                            break;
                    }
                    result.Add(dto);
                }

                response.Data = result;
                response.statusCode = HttpStatusCode.OK;
                response.Message = "Fetched notifications successfully.";
            }
            catch (Exception ex)
            {
                response.statusCode = HttpStatusCode.InternalServerError;
                response.Message = ex.Message;
            }
            return response;
        }
        public async Task<StatusResponse<bool>> MarkAsRead(int notificationId)
        {
            var response = new StatusResponse<bool>();
            try
            {
                var data = await _notificationRepository.GetById(notificationId);
                if (data == null)
                {
                    response.statusCode = HttpStatusCode.NotFound;
                    response.Message = "Notification not found.";
                    return response;
                }
                data.IsRead = true;
                _notificationRepository.Update(data);
                await _notificationRepository.SaveChangesAsync();
                response.statusCode = HttpStatusCode.OK;
                response.Message = "Notification marked as read successfully.";
                response.Data = true;
            }
            catch (Exception ex)
            {
                response.statusCode = HttpStatusCode.InternalServerError;
                response.Message = ex.Message;
            }
            return response;
        }

        public Task<StatusResponse<bool>> MarkAsReadAll(int userId)
        {
            throw new NotImplementedException();
        }
    }
}
