using Database.DTO.Response;
using System.Threading.Tasks;
using Database.DTO.Request;

namespace Services.Services.Interface
{
    public interface ITeamService
    {
        Task<StatusResponse<TeamResponseDTO>> GetTeamWithMembersAsync(int teamId);
        Task<StatusResponse<TeamResponseDTO>> CreateTeamAsync(TeamRequestDTO dto);
    }
}
