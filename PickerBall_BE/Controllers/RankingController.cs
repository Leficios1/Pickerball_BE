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
    }
}
