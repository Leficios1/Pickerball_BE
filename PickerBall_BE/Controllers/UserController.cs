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
        private readonly IReFeeSevice _refreeService;

        public UserController(IUserServices userServices, IReFeeSevice refreeService)
        {
            _userServices = userServices;
            _refreeService = refreeService;
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
        public async Task<IActionResult> GetRefeeUser()
        {
            var response = await _userServices.getAllRefeeUser();
            return StatusCode((int)response.statusCode, response);
        }
        [HttpGet("getAllRefeeForMobile")]
        public async Task<IActionResult> getAllRefeeForMobile()
        {
            var response = await _refreeService.GetAllForMobile();
            return StatusCode((int)response.statusCode, response);
        }
        [HttpGet("GetAllPlayer")]
        public async Task<IActionResult> GetAllPlayer()
        {
            var response = await _userServices.getAllPlayerUser();
            return StatusCode((int)response.statusCode, response);
        }
        [HttpPost("AcceptUser/{sponserId}")]
        public async Task<IActionResult> AcceptUser([FromRoute] int sponserId)
        {
            var response = await _userServices.AcceptUser(sponserId);
            return StatusCode((int)response.statusCode, response);
        }

        [HttpPatch("UpdateUser/{id}")]
        public async Task<IActionResult> UpdateUser([FromRoute] int id, [FromBody] UserUpdateRequestDTO dto)
        {
            var response = await _userServices.UpdateUser(dto, id);
            return StatusCode((int)response.statusCode, response);
        }
        [HttpDelete("DeletedUser/{UserId}")]
        public async Task<IActionResult> DeletedUser([FromRoute] int UserId)
        {
            var response = await _userServices.DeletedUser(UserId);
            return StatusCode((int)response.statusCode, response);
        }
        [HttpPost("create-referee")]
        public async Task<IActionResult> CreateReferee([FromBody] RefereeCreateRequestDTO dto)
        {
            var response = await _userServices.CreateReferee(dto);
            return StatusCode((int)response.statusCode, response);
        }
    }
}
