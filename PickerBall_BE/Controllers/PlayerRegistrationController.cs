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
        public async Task<IActionResult> ChangeStatus([FromBody] TouramentRegistrationDTO dto)
        {
            var response = await _playerRegistrationServices.AcceptPlayer(dto.PlayerId, dto.isAccept, dto.TournamentId);
            return StatusCode((int)response.statusCode, new { data = response.Data, message = response.Message });
        }

        [HttpPost("CreateRegistration")]
        public async Task<IActionResult> CreateRegistration([FromBody] TouramentRegistrationDTO touramentRegistrationDTO)
        {
            var response = await _playerRegistrationServices.CreateRegistration(touramentRegistrationDTO);
            return StatusCode((int)response.statusCode, response);
        } 
        [HttpGet("GetAll")]
        public async Task<IActionResult> GetAll()
        {
            var response = await _playerRegistrationServices.GetAll();
            return StatusCode((int)response.statusCode, response);
        } 
        [HttpGet("GetById/{id}")]
        public async Task<IActionResult> GetById([FromRoute] int id)
        {
            var response = await _playerRegistrationServices.GetById(id);
            return StatusCode((int)response.statusCode, response);
        } 
        [HttpGet("GetByTouramentId/{tourId}")]
        public async Task<IActionResult> GetByTouramentId([FromRoute] int tourId)
        {
            var response = await _playerRegistrationServices.GetByTouramentId(tourId);
            return StatusCode((int)response.statusCode, response);
        }
    }
}
