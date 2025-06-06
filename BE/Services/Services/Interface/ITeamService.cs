using Database.DTO.Response;
using System.Collections.Generic;
using System.Threading.Tasks;
using Database.DTO.Request;

namespace Services.Services.Interface
{
    public interface ITeamService
    {
        Task<StatusResponse<TeamResponseDTO>> GetTeamWithMembersAsync(int teamId);
        Task<StatusResponse<TeamResponseDTO>> CreateTeamAsync(TeamRequestDTO dto);
        Task<StatusResponse<List<TeamResponseDTO>>> GetTeamsWithMatchingIdAsync(int matchingId);
        Task<StatusResponse<TeamResponseDTO>> GetTeamByIdAsync(int teamId);
        Task<StatusResponse<TeamResponseDTO>> UpdateTeamAsync(int teamId, TeamRequestDTO dto);
        Task<StatusResponse<bool>> DeleteTeamAsync(int teamId);
    }
}
