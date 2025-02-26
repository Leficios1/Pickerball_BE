using Database.DTO.Request;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Services.Services;
using Services.Services.Interface;

namespace PickerBall_BE.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class FriendController : ControllerBase
    {
        private readonly IFriendServices _friendService;

        public FriendController(IFriendServices friendService)
        {
            _friendService = friendService;
        }

        [HttpGet("GetFriend/{userId}")]
        public async Task<IActionResult> getFriend([FromRoute] int userId)
        {
            var response = await _friendService.GetFriends(userId);
            return StatusCode((int)response.statusCode, new { data = response.Data, message = response.Message });
        }
        [HttpGet("GetFriendRequest/{userId}")]
        public async Task<IActionResult> getFriendRequest([FromRoute] int userId)
        {
            var response = await _friendService.GetFriendRequests(userId);
            return StatusCode((int)response.statusCode, new { data = response.Data, message = response.Message });
        }
        [HttpPost("AddFriend")]
        public async Task<IActionResult> AddFriend([FromBody] FriendRequestDTO dto)
        {
            var response = await _friendService.AddFriend(dto);
            return StatusCode((int)response.statusCode, new { data = response.Data, message = response.Message });
        }
        [HttpPost("AcceptFriend")]
        public async Task<IActionResult> AcceptFriend([FromBody] FriendRequestDTO dto)
        {
            var response = await _friendService.AcceptFriendRequest(dto);
            return StatusCode((int)response.statusCode, new { data = response.Data, message = response.Message });
        }
        [HttpDelete("RemoveFriend")]
        public async Task<IActionResult> RemoveFriend([FromBody] FriendRequestDTO dto)
        {
            var response = await _friendService.RemoveFriend(dto);
            return StatusCode((int)response.statusCode, new { data = response.Data, message = response.Message });
        }
    }
}
