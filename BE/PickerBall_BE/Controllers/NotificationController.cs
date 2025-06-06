using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Services.Services.Interface;

namespace PickerBall_BE.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class NotificationController : ControllerBase
    {
        private readonly INotificationServices _notificationServices;

        public NotificationController(INotificationServices notificationServices)
        {
            _notificationServices = notificationServices;
        }
        [HttpGet("getNotificationByUserId/{userId}")]
        public async Task<IActionResult> GetNotificationByUserId([FromRoute] int userId)
        {
            var response = await _notificationServices.GetNotificationByUserId(userId);
            return StatusCode((int)response.statusCode, response);
        }
        [HttpGet("MarkAsRead/{NotificationId}")]
        public async Task<IActionResult> MarkAsRead([FromRoute] int NotificationId)
        {
            var response = await _notificationServices.MarkAsRead(NotificationId);
            return StatusCode((int)response.statusCode, response);
        }

        [HttpGet("CountNotiOfUser/{userId}")]
        public async Task<IActionResult> CountNotiOfUser([FromRoute] int userId)
        {
            var response = await _notificationServices.CountNotiOfUser(userId);
            return StatusCode((int)response.statusCode, response);
        }
    }
}
