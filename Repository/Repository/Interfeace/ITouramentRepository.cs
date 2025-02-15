using Database.DTO.Response;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Repository.Repository.Interfeace
{
    public interface ITouramentRepository
    {
        public Task<StatusResponse<TournamentResponseDTO>> CreateTournament(TournamentRequestDTO dto);
        public Task<StatusResponse<TournamentResponseDTO>> UpdateTournament(TournamentRequestDTO dto);
        public Task<StatusResponse<TournamentResponseDTO>> DeleteTournament(int id);
        public Task<StatusResponse<TournamentResponseDTO>> GetTournament(int id);
        public Task<StatusResponse<List<TournamentResponseDTO>>> GetAllTournament();

    }
}
