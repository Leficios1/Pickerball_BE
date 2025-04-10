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
        private readonly ITournamentTeamRequestServices _tournamentTeamRequestServices;
        private readonly IVnpayService _vpnpayService;
        public TouramentController(ITouramentServices touramentServices, ITournamentTeamRequestServices tournamentTeamRequestServices, IVnpayService vnpayService)
        {
            _touramentServices = touramentServices;
            _tournamentTeamRequestServices = tournamentTeamRequestServices;
            _vpnpayService = vnpayService;
        }

        [HttpPost("Create")]
        public async Task<IActionResult> CreateTournament([FromBody] TournamentRequestDTO tournamentRequestDTO)
        {
            var response = await _touramentServices.CreateTournament(tournamentRequestDTO);
            return StatusCode((int)response.statusCode, response);
        } 
        [HttpPost("DonateForTourament")]
        public async Task<IActionResult> DonateForTourament([FromBody] SponnerTouramentRequestDTO dto)
        {
            var response = await _vpnpayService.CallApiByUserId(dto.SponnerId, dto.ReturnUrl, null, dto.TouramentId, dto.Amount);
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
        [HttpGet("CheckJoinTouramentOrNot/{UserId}")]
        public async Task<IActionResult> CheckJoinTouramentOrNot([FromRoute] int UserId)
        {
            var response = await _touramentServices.checkAllJoinTourament(UserId);
            return StatusCode((int)response.statusCode, response);
        }
        [HttpGet("CheckJoinTouramentOrNot/{UserId}/{TouramentId}")]
        public async Task<IActionResult> CheckJoinTouramentOrNot([FromRoute] int UserId, [FromRoute] int TouramentId)
        {
            var response = await _touramentServices.checkJoinTounramentorNot(UserId, TouramentId);
            return StatusCode((int)response.statusCode, response);
        }
        [HttpGet("GetTouramentByPlayerId/{PlayerId}")]
        public async Task<IActionResult> GetTouramentByPlayerId([FromRoute] int PlayerId)
        {
            var response = await _touramentServices.getByPlayerId(PlayerId);
            return StatusCode((int)response.statusCode, response);
        }
        [HttpGet("GetAllSponnerByTouramentId/{TouramnetId}")]
        public async Task<IActionResult> GetAllSponnerByTouramentId([FromRoute] int TouramnetId)
        {
            var response = await _touramentServices.GetAllSponnerByTouramentId(TouramnetId);
            return StatusCode((int)response.statusCode, response);
        }

        [HttpGet("GetAllTouramentBySponnerId/{SponnerId}")]
        public async Task<IActionResult> GetAllTouramentBySponnerId([FromRoute] int SponnerId)
        {
            var response = await _touramentServices.GetAllTouramentBySponnerId(SponnerId);
            return StatusCode((int)response.statusCode, response);
        }

        [HttpGet("GetTournamentRequest/{UserId}")]
        public async Task<IActionResult> GetTournamentRequest([FromRoute] int UserId)
        {
            var response = await _touramentServices.GetTournamentHaveRequest(UserId);
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
