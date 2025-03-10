using AutoMapper;
using Database.DTO.Response;
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
                var notifications = await _notificationRepository.Get().Where(x => x.UserId == userId).ToListAsync();
                if (notifications == null)
                {
                    response.statusCode = HttpStatusCode.OK;
                    response.Message = "Don't have notification";
                    return response;
                }
                response.Data = _mapper.Map<List<NotificationResponseDTO>>(notifications);
                response.statusCode = HttpStatusCode.OK;
                response.Message = "Get notification successfully!";
            }
            catch (Exception e)
            {
                response.Message = e.Message;
                response.statusCode = HttpStatusCode.InternalServerError;
            }
            return response;
        }

        public Task<StatusResponse<bool>> MarkAsRead(int notificationId)
        {
            throw new NotImplementedException();
        }

        public Task<StatusResponse<bool>> MarkAsReadAll(int userId)
        {
            throw new NotImplementedException();
        }
    }
}
