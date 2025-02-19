using Database.DTO.Request;
using Database.DTO.Response;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Services.Services.Interface
{
    public interface ITouramentServices
    {
        public Task<StatusResponse<TournamentResponseDTO>> CreateTournament(TournamentRequestDTO dto);
        public Task<StatusResponse<TournamentResponseDTO>> UpdateTournament(TournamentRequestDTO dto);
        public Task<StatusResponse<TournamentResponseDTO>> DeleteTournament(int id);
        public Task<StatusResponse<List<TournamentResponseDTO>>> GetAllTournament(int? PageNumber, int? Pagesize, bool isOrderbyCreateAt);
        public Task<StatusResponse<TournamentResponseDTO>> getById(int id);
        public Task<StatusResponse<List<TournamentResponseDTO>>> getByPlayerId(int PlayerId);
    }
}
