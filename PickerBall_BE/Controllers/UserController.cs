using Database.DTO.Request;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Services.Services.Interface;

namespace PickerBall_BE.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class UserController : ControllerBase
    {
        private readonly IUserServices _userServices;

        public UserController(IUserServices userServices)
        {
            _userServices = userServices;
        }

        [HttpGet("GetAllUser")]
        public async Task<IActionResult> GetAllUser(int? PageNumber, int? Pagesize, bool isOrderbyCreateAt)
        {
            var response = await _userServices.getAllUser(PageNumber, Pagesize, isOrderbyCreateAt);
            return StatusCode((int)response.statusCode, response);
        }
        [HttpGet("GetUserById/{UserId}")]
        public async Task<IActionResult> GetUserById([FromRoute] int UserId)
        {
            var response = await _userServices.getUserById(UserId);
            return StatusCode((int)response.statusCode, response);
        }
        [HttpGet("GetAllRefee")]
        public async Task<IActionResult> GetRefeeUserById()
        {
            var response = await _userServices.getAllRefeeUser();
            return StatusCode((int)response.statusCode, response);
        }
        [HttpPost("AcceptUser/{sponserId}")]
        public async Task<IActionResult> AcceptUser([FromRoute] int sponserId)
        {
            var response = await _userServices.AcceptUser(sponserId);
            return StatusCode((int)response.statusCode, response);
        }

        [HttpPut("UpdateUser")]
        public async Task<IActionResult> UpdateUser([FromBody] UserUpdateRequestDTO dto)
        {
            var response = await _userServices.UpdateUser(dto);
            return StatusCode((int)response.statusCode, response);
        }
        [HttpDelete("DeletedUser/{UserId}")]
        public async Task<IActionResult> DeletedUser([FromRoute] int UserId)
        {
            var response = await _userServices.DeletedUser(UserId);
            return StatusCode((int)response.statusCode, response);
        }
    }
}
