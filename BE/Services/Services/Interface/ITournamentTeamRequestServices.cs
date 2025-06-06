using Database.DTO.Request;
using Database.DTO.Response;
using Microsoft.EntityFrameworkCore.Query;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Services.Services.Interface
{
    public interface ITournamentTeamRequestServices
    {
        Task<StatusResponse<bool>> SendTeamRequest(TournamentTeamRequestDTO dto);
        Task<StatusResponse<bool>> RespondToTeamRequest(int requestId, bool isAccept);
        Task<StatusResponse<List<TournamentTeamRequestResponseDTO>>> GetTeamRequestByResponseUser(int PlayerId);
        Task<StatusResponse<List<TournamentTeamRequestResponseDTO>>> GetTeamRequestByRequestUser(int PlayerId);
        Task<StatusResponse<TouramentRegistraionResponseDTO>> CheckAccept(int userId, int touramentId);

    }
}
