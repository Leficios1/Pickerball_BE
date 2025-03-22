using Database.DTO.Request;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Services.Services;
using Services.Services.Interface;

namespace PickerBall_BE.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class PlayerController : ControllerBase
    {
        private readonly IPlayerServices _playerServices;

        public PlayerController(IPlayerServices playerServices)
        {
            _playerServices = playerServices;
        }

        [HttpPost("CreatePlayer")]
        public async Task<IActionResult> CreatePlayer([FromBody] PlayerDetailsRequest player)
        {
            var response = await _playerServices.CreatePlayer(player);
            return StatusCode((int)response.statusCode, response);
        }

        [HttpGet("GetAllPlayer")]
        public async Task<IActionResult> GetAllPlayer(int? PageNumber, int? Pagesize, bool isOrderbyCreateAt)
        {
            var response = await _playerServices.PagingPlayers(PageNumber, Pagesize, isOrderbyCreateAt);
            return StatusCode((int)response.statusCode, response);
        }
    }
}
