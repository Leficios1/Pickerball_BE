using Database.DTO.Request;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore.Internal;
using Services.Services;
using Services.Services.Interface;

namespace PickerBall_BE.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class PlayerRegistrationController : ControllerBase
    {
        private readonly ITouramentRegistrationServices _playerRegistrationServices;

        public PlayerRegistrationController(ITouramentRegistrationServices playerRegistrationServices)
        {
            _playerRegistrationServices = playerRegistrationServices;
        }

        [HttpPut("ChangeStatus")]
        public async Task<IActionResult> ChangeStatus([FromBody] UpdateApprovalDTO updateApprovalDTO)
        {
            var response = await _playerRegistrationServices.AcceptPlayer(updateApprovalDTO);
            return StatusCode((int)response.statusCode, new { data = response.Data, message = response.Message });
        }
        
        [HttpPost("CreateRegistration")]
        public async Task<IActionResult> CreateRegistration([FromBody] TouramentRegistrationDTO touramentRegistrationDTO)
        {
            var response = await _playerRegistrationServices.CreateRegistration(touramentRegistrationDTO);
            return StatusCode((int)response.statusCode, response);
        }
    }
}
