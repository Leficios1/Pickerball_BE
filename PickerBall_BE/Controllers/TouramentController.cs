using Azure;
using Database.DTO.Request;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Services.Partial;
using Services.Services.Interface;

namespace PickerBall_BE.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class TouramentController : ControllerBase
    {
        private readonly ITouramentServices _touramentServices;

        public TouramentController(ITouramentServices touramentServices)
        {
            _touramentServices = touramentServices;
        }

        [HttpPost("Create")]
        public async Task<IActionResult> CreateTournament([FromBody] TournamentRequestDTO tournamentRequestDTO)
        {
            var response = await _touramentServices.CreateTournament(tournamentRequestDTO);
            return StatusCode((int)response.statusCode, response);
        }
        [HttpGet("GetAllTournament")]
        public async Task<IActionResult> GetAllTournament(int? PageNumber, int? Pagesize, bool isOrderbyCreateAt)
        {
            var response = await _touramentServices.GetAllTournament(PageNumber, Pagesize, isOrderbyCreateAt);
            return StatusCode((int)response.statusCode, response);
        }
        [HttpGet("GetTournamentById/{TournamentId}")]
        public async Task<IActionResult> GetTournamentById([FromRoute] int TournamentId)
        {
            var response = await _touramentServices.getById(TournamentId);
            return StatusCode((int)response.statusCode, response);
        }
        [HttpGet("GetTouramentByPlayerId/{PlayerId}")]
        public async Task<IActionResult> GetTouramentByPlayerId([FromRoute] int PlayerId)
        {
            var response = await _touramentServices.getByPlayerId(PlayerId);
            return StatusCode((int)response.statusCode, response);
        }
        [HttpPatch("UpdateTournament/{id}")]
        public async Task<IActionResult> UpdateTournament([FromBody] TournamenUpdatetRequestDTO tournamentRequestDTO, [FromRoute] int id)
        {
            var response = await _touramentServices.UpdateTournament(tournamentRequestDTO, id);
            return StatusCode((int)response.statusCode, response);
        }
    }
}
