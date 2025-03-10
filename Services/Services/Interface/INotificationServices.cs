using Database.DTO.Response;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Services.Services.Interface
{
    public interface INotificationServices
    {
        //Task<StatusResponse<bool>> SendNotification(NotificationDTO dto);
        Task<StatusResponse<List<NotificationResponseDTO>>> GetNotificationByUserId(int userId);
        Task<StatusResponse<bool>> MarkAsRead(int notificationId);
        Task<StatusResponse<bool>> MarkAsReadAll(int userId);
        Task<StatusResponse<bool>> DeleteNotification(int notificationId);
        Task<StatusResponse<bool>> DeleteAllNotification(int userId);
    }
}
