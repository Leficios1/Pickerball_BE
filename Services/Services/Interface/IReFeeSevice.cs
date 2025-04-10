using Database.DTO.Request;
using Database.DTO.Response;
using Database.Model;

namespace Services.Services.Interface
{
    public interface IReFeeSevice
    {
        Task<Refree> CreateRefreeAsync(CreateRefreeDTO refree);

        Task<StatusResponse<Refree>> UpdateRefree(UpdateRefreeDTO dto, int id);
        Task<List<Refree>> GetByRefreeCode(string id);
        Task<List<Refree>> GetAll();
        Task<StatusResponse<List<MatchResponseDTO>>> GetMatchByRefreeCode(int UserId);
        Task<StatusResponse<List<TournamentResponseDTO>>> GetTouramentByRefreeId(int userId);
        // Task<List<Refree>> GetAllRefreesAsync();
        // Task<Refree> UpdateRefreeAsync(Refree refree);
        // Task DeleteRefreeAsync(int refreeId);
    }
}
