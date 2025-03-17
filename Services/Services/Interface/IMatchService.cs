using Database.DTO.Request;
using Database.DTO.Response;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Services.Services.Interface
{
    public interface IMatchService
    {
        Task<StatusResponse<RoomResponseDTO>> CreateRoomWithTeamsAsync(CreateRoomDTO dto);
        Task<StatusResponse<MatchResponseDTO>> CreateRoomAsync(MatchRequestDTO dto);
        Task<StatusResponse<RoomResponseDTO>> GetRoomByIdAsync(int id);
        Task<StatusResponse<bool>> DeleteRoomAsync(int id);
        Task<StatusResponse<MatchResponseDTO>> UpdateRoomAsync(int id, MatchUpdateRequestDTO dto);
        Task<StatusResponse<List<MatchResponseDTO>>> GetMatchesByTouramentId(int TouramentId);
        Task<StatusResponse<TeamResponseDTO>> AddPlayerToTeamAsync(AddPlayerToTeamDTO dto);
        Task<StatusResponse<IEnumerable<MatchResponseDTO>>> GetAllMatchingsAsync();
        
        Task<StatusResponse<IEnumerable<RoomResponseDTO>>> GetAllPublicRoomsAsync();

        Task<StatusResponse<List<RoomResponseDTO>>> GetRoomsByUserIdAsync(int userId);
        Task<StatusResponse<bool>> joinMatch(JoinMatchRequestDTO dto);
        Task<StatusResponse<bool>> endMatch(int MatchId, int Team1Score, int Team2Score);

    }
}
