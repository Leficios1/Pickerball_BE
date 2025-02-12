using Database.DTO.Request;
using Database.DTO.Response;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Services.Services.Interface
{
    public interface IMatchService
    {
        Task<StatusResponse<MatchResponseDTO>> CreateRoomAsync(MatchRequestDTO dto);
        Task<StatusResponse<MatchResponseDTO>> GetRoomByIdAsync(int id);
        Task<StatusResponse<IEnumerable<MatchResponseDTO>>> GetPublicRoomsAsync();
        Task<StatusResponse<bool>> DeleteRoomAsync(int id);
        Task<StatusResponse<MatchResponseDTO>> UpdateRoomAsync(int id, MatchRequestDTO dto);
    }
}
