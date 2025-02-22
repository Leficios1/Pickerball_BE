using System.Net;
using Database.DTO.Request;
using Database.DTO.Response;
using Microsoft.AspNetCore.Mvc;
using Services.Services.Interface;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace PickerBall_BE.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class MatchController : ControllerBase
    {
        private readonly IMatchService _matchService;
        private readonly ITeamService _teamService;
        private readonly ITeamMembersService _teamMembersService;

        public MatchController(IMatchService matchService, ITeamService teamService, ITeamMembersService teamMembersService)
        {
            _matchService = matchService;
            _teamService = teamService;
            _teamMembersService = teamMembersService;
        }

        [HttpPost]
        public async Task<StatusResponse<RoomResponseDTO>> CreateRoomAsync(CreateRoomDTO dto)
        {
            return await _matchService.CreateRoomWithTeamsAsync(dto);
        }

        [HttpGet]
        public async Task<StatusResponse<IEnumerable<MatchResponseDTO>>> GetAllRoomsAsync()
        {
            return await _matchService.GetAllMatchingsAsync();
        }

        [HttpGet("user/room/{userId}")]
        public async Task<StatusResponse<List<RoomResponseDTO>>> GetRoomsByUserIdAsync(int userId)
        {
            return await _matchService.GetRoomsByUserIdAsync(userId);
        }
        
        [HttpGet("{id}")]
        public async Task<ActionResult<StatusResponse<RoomResponseDTO>>> GetRoomByIdAsync(int id)
        {
            var response = await _matchService.GetRoomByIdAsync(id);
            return Ok(response);
        }
        
        [HttpGet("public")]
        public async Task<StatusResponse<IEnumerable<RoomResponseDTO>>> GetPublicRoomsAsync()
        {
            return await _matchService.GetAllPublicRoomsAsync();
        }
        
        [HttpPost("team/player")]
        public async Task<StatusResponse<TeamResponseDTO>> AddPlayerToTeamAsync([FromBody] AddPlayerToTeamDTO dto)
        {
            return await _matchService.AddPlayerToTeamAsync(dto);
        }

        [HttpDelete("team/player")]
        public async Task<StatusResponse<bool>> DeletePlayerFromTeamAsync([FromBody] DeletePlayerToTeamDTO dto)
        {
            return await _teamMembersService.DeleteTeamMemberAsync(dto.PlayerId, dto.TeamId);
        }

        // Admin endpoints
        [HttpPut("admin/room/{id}")]
        public async Task<StatusResponse<MatchResponseDTO>> UpdateRoomAsync(int id, [FromBody] MatchRequestDTO dto)
        {
            return await _matchService.UpdateRoomAsync(id, dto);
        }

        [HttpPatch("admin/team/{id}")]
        public async Task<StatusResponse<TeamResponseDTO>> PatchTeamAsync(int id, [FromBody] TeamRequestDTO dto)
        {
            return await _teamService.UpdateTeamAsync(id, dto);
        }

        [HttpDelete("admin/room/{id}")]
        public async Task<StatusResponse<bool>> DeleteRoomAsync(int id)
        {
            return await _matchService.DeleteRoomAsync(id);
        }
    }
}