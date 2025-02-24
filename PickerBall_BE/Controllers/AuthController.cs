using Azure;
using Database.DTO.Request;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Http.HttpResults;
using Microsoft.AspNetCore.Mvc;
using Services.Services;
using Services.Services.Interface;

namespace PickerBall_BE.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AuthController : ControllerBase
    {
        private readonly IAuthServices _authServices;

        public AuthController(IAuthServices authServices)
        {
            _authServices = authServices;
        }

        [HttpPost("login")]
        public async Task<IActionResult> Login(AuthRequestDTO dto)
        {
            var response = await _authServices.LoginAccount(dto);
            return StatusCode((int)response.statusCode, new { data = response.Data, message = response.Message });
        }

        [HttpPost("register")]
        public async Task<IActionResult> Register(UserRegisterRequestDTO registerDto)
        {
            var response = await _authServices.RegisterAsync(registerDto);
            return StatusCode((int)response.statusCode, new { data = response.Data, message = response.Message });
        }
        [HttpPost("refresh-token")]
        public async Task<IActionResult>RefershToken(RefershTokenRequestDTO dto)
        {
            var response = await _authServices.getRefershToken(dto);
            return StatusCode((int)response.statusCode, new { data = response.Data, message = response.Message });
        }
        [HttpGet("GetUserByToken/{token}")]
        public async Task<IActionResult> GetUserByToken(string token)
        {
            var response = await _authServices.GetUserByToken(token);
            return Ok(response); 
        }
        [HttpPost("refereesRegister")]
        public async Task<IActionResult> refereesRegister(UserRegisterRequestDTO registerDto)
        {
            var response = await _authServices.RegisterAsync(registerDto);
            return StatusCode((int)response.statusCode, new { data = response.Data, message = response.Message });
        }
    }
}
