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
        Task<StatusResponse<List<RoomResponseDTO>>> GetAllMatchCompetitiveAndCustom();

        Task<StatusResponse<List<RoomResponseDTO>>> GetRoomsByUserIdAsync(int userId);
        Task<StatusResponse<bool>> joinMatch(JoinMatchRequestDTO dto);
        Task<StatusResponse<bool>> endMatchTourament(EndMatchTouramentRequestDTO dto);
        Task<StatusResponse<EndMatchResponseDTO>> GetEndMatchDetailsOfBO3(int MatchId);
        Task<StatusResponse<bool>> UpdateURLEndMatch(int matchId, string url);
        Task<StatusResponse<bool>> endMatchCustomOrChallenge(EndMatchNormalRequestDTO dto);
        Task<StatusResponse<MatchResponseDTO>> UpdateMatch(int MatchId, MatchUpdateRequestForNormalMatchRequestDTO dto);
        Task<StatusResponse<List<MatchHistoryResponseDTO>>> HistoryMatchByUserId(int userId);
    }
}
