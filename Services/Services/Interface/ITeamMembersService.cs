using Database.DTO.Request;
using Database.DTO.Response;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Services.Services.Interface
{
    public interface ITeamMembersService
    {
        Task<StatusResponse<TeamMemberDTO>> CreateTeamMemberAsync(TeamMemberRequestDTO dto);
        Task<StatusResponse<IEnumerable<TeamMemberDTO>>> GetTeamMembersByTeamIdAsync(int teamId);
        Task<StatusResponse<IEnumerable<TeamMemberDTO>>> GetTeamMembersByPlayerIdAsync(int playerId);
    }
}