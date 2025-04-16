using Database.DTO.Request;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Services.Services.Interface;

namespace PickerBall_BE.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class PlayerController : ControllerBase
    {
        private readonly IPlayerServices _playerServices;
        private readonly IUserServices _userServices;
        public PlayerController(IPlayerServices playerServices, IUserServices userServices)
        {
            _playerServices = playerServices;
            _userServices = userServices;
        }

        [HttpPost("CreatePlayer")]
        public async Task<IActionResult> CreatePlayer([FromBody] PlayerDetailsRequest player)
        {
            var response = await _playerServices.CreatePlayer(player);
            return StatusCode((int)response.statusCode, response);
        }

        [HttpPut("UpdatePointAndLevelPlayer/{userId}/{Level}/{Point}")]
        public async Task<IActionResult> UpdatePointAndLevelPlayer([FromRoute] int userId, [FromRoute]int Level, [FromRoute] int Point)
        {
            var response = await _userServices.UpdatePointPlayer(userId, Point, Level);
            return StatusCode((int)response.statusCode, response);
        }
    }
}
