using Database.DTO.Request;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Services.Services;
using Services.Services.Interface;

namespace PickerBall_BE.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class MatcheSendRequestController : ControllerBase
    {
        private readonly IMatchSentRequestServices _matchSentRequestServices;

        public MatcheSendRequestController(IMatchSentRequestServices matchSentRequestServices)
        {
            _matchSentRequestServices = matchSentRequestServices;
        }

        [HttpGet("GetByReceviedId/{ReceviedId}")]
        public async Task<IActionResult> getByReceviedId([FromRoute] int ReceviedId)
        {
            var response = await _matchSentRequestServices.GetResponseByUserAcceptId(ReceviedId);
            return StatusCode((int)response.statusCode, new { data = response.Data, message = response.Message });
        }
        [HttpGet("GetByRequestId/{RequestId}")]
        public async Task<IActionResult> getByRequestId([FromRoute] int RequestId)
        {
            var response = await _matchSentRequestServices.GetByUserSendRequestId(RequestId);
            return StatusCode((int)response.statusCode, new { data = response.Data, message = response.Message });
        }
        [HttpGet("GetById/{Id}")]
        public async Task<IActionResult> getById([FromRoute] int Id)
        {
            var response = await _matchSentRequestServices.getById(Id);
            return StatusCode((int)response.statusCode, new { data = response.Data, message = response.Message });
        }
        [HttpPost("Create")]
        public async Task<IActionResult> CreateMatchSentRequest([FromBody] MatchSentRequestRequestDTO matchSentRequestDTO)
        {
            var response = await _matchSentRequestServices.SentRequest(matchSentRequestDTO);
            return StatusCode((int)response.statusCode, new { data = response.Data, message = response.Message });
        }
        [HttpPut("AcceptRequest")]
        public async Task<IActionResult> AcceptRequest([FromBody] AcceptSentRequestDTO dto)
        {
            var response = await _matchSentRequestServices.AcceptRequest(dto.RequestId, dto.UserAcceptId, dto.Status);
            return StatusCode((int)response.statusCode, new { data = response.Data, message = response.Message });
        }
    }
}
