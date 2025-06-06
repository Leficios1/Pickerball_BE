using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Services.Services;
using Services.Services.Interface;

namespace PickerBall_BE.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AchivementController : ControllerBase
    {
        private readonly IAchivementServices _achivementServices;

        public AchivementController(IAchivementServices achivementServices)
        {
            _achivementServices = achivementServices;
        }

        [HttpGet("GetAchivement/{userId}")]
        public async Task<IActionResult> GetAchivementByUserId([FromRoute] int userId)
        {
            var response = await _achivementServices.GetAchivementByUserId(userId);
            return StatusCode((int)response.statusCode, new { data = response.Data, message = response.Message });
        }
    }
}
