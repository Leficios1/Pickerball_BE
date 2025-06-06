using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Services.Services.Interface;

namespace PickerBall_BE.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class RankingController : ControllerBase
    {
        private readonly IRankingServices _rankingServices;

        public RankingController(IRankingServices rankingServices)
        {
            _rankingServices = rankingServices;
        }

        [HttpGet("LeaderBoard")]
        public async Task<IActionResult> LeaderBoard()
        {
            var response = await _rankingServices.LeaderBoard();
            return StatusCode((int)response.statusCode, new { data = response.Data, message = response.Message });
        }
        [HttpGet("LeaderBoardTourament/{tourID}")]
        public async Task<IActionResult> LeaderBoardTourament([FromRoute] int tourID)
        {
            var response = await _rankingServices.LeaderBoardTourament(tourID);
            return StatusCode((int)response.statusCode, new { data = response.Data, message = response.Message });
        }
        [HttpGet("giveAward/{tourID}")]
        public async Task<IActionResult> GiveAward([FromRoute] int tourID)
        {
            var response = await _rankingServices.AwardForPlayer(tourID);
            return StatusCode((int)response.statusCode, new { data = response.Data, message = response.Message });
        }
        [HttpGet("GetRuleOfAward")]
        public async Task<IActionResult> GetRuleOfAward()
        {
            var response = await _rankingServices.GetRuleOfAwardForPlayer();
            return StatusCode((int)response.statusCode, new { data = response.Data, message = response.Message });
        }
    }
}
