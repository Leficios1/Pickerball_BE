using Database.DTO.Request;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore.Internal;
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

        [HttpPost("CreateRegistration")]
        public async Task<IActionResult> CreateRegistration([FromBody] TouramentRegistrationDTO touramentRegistrationDTO)
        {
            var response = await _playerRegistrationServices.CreateRegistration(touramentRegistrationDTO);
            return StatusCode((int)response.statusCode, response);
        }
    }
}
