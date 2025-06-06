using Database.DTO.Request;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Services.Services.Interface;

namespace PickerBall_BE.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class TournamentTeamRequestController : ControllerBase
    {
        private readonly ITournamentTeamRequestServices _tournamentTeamRequestServices;

        public TournamentTeamRequestController(ITournamentTeamRequestServices tournamentTeamRequestServices)
        {
            _tournamentTeamRequestServices = tournamentTeamRequestServices;
        }

        //[HttpPost("SendTeamRequest")]
        //public async Task<IActionResult> SendTeamRequest([FromBody] TournamentTeamRequestDTO dto)
        //{
        //    var response = await _tournamentTeamRequestServices.SendTeamRequest(dto);
        //    return StatusCode((int)response.statusCode, response);
        //}

        [HttpPost("RespondToTeamRequest/{requestId}")]
        public async Task<IActionResult> RespondToTeamRequest([FromRoute] int requestId, [FromBody] bool isAccept)
        {
            var response = await _tournamentTeamRequestServices.RespondToTeamRequest(requestId, isAccept);
            return StatusCode((int)response.statusCode, response);
        }
        [HttpGet("GetTeamRequestByRequestUser/{PlayerId}")]
        public async Task<IActionResult> GetTeamRequestByRequestUser([FromRoute] int PlayerId)
        {
            var response = await _tournamentTeamRequestServices.GetTeamRequestByRequestUser(PlayerId);
            return StatusCode((int)response.statusCode, response);
        }
        [HttpGet("GetTeamRequestByUserId/{UserId}/{TouramentId}")]
        public async Task<IActionResult> GetTeamRequestByRequestUser([FromRoute] int UserId, [FromRoute] int TouramentId)
        {
            var response = await _tournamentTeamRequestServices.CheckAccept(UserId, TouramentId);
            return StatusCode((int)response.statusCode, response);
        }
        [HttpGet("GetTeamRequestByReceiverUser/{PlayerId}")]
        public async Task<IActionResult> GetTeamRequestByReceiverUser([FromRoute] int PlayerId)
        {
            var response = await _tournamentTeamRequestServices.GetTeamRequestByResponseUser(PlayerId);
            return StatusCode((int)response.statusCode, response);
        }
    }
}
