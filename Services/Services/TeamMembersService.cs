using Database.DTO.Request;
using Database.DTO.Response;
using Microsoft.AspNetCore.Mvc;
using Services.Services.Interface;
using System.Collections.Generic;
using System.Net;
using System.Threading.Tasks;

namespace YourNamespace.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class TeamMembersController : ControllerBase
    {
        private readonly ITeamMembersService _teamMembersService;

        public TeamMembersController(ITeamMembersService teamMembersService)
        {
            _teamMembersService = teamMembersService;
        }

        [HttpPost("create")]
        public async Task<IActionResult> CreateTeamMemberAsync(TeamMemberRequestDTO dto)
        {
            var response = await _teamMembersService.CreateTeamMemberAsync(dto);
            return StatusCode((int)response.statusCode, new { data = response.Data, message = response.Message });
        }

        [HttpGet("team/{teamId}")]
        public async Task<IActionResult> GetTeamMembersByTeamIdAsync(int teamId)
        {
            var response = await _teamMembersService.GetTeamMembersByTeamIdAsync(teamId);
            return StatusCode((int)response.statusCode, new { data = response.Data, message = response.Message });
        }

        [HttpGet("player/{playerId}")]
        public async Task<IActionResult> GetTeamMembersByPlayerIdAsync(int playerId)
        {
            var response = await _teamMembersService.GetTeamMembersByPlayerIdAsync(playerId);
            return StatusCode((int)response.statusCode, new { data = response.Data, message = response.Message });
        }
    }
}