using Database.Model;
using System.Collections.Generic;
using System.Threading.Tasks;
using Repository.Repository.Interfeace;

namespace Repository.Repository.Interface
{
    public interface IMatchesRepository : IBaseRepository<Matches>
    {
        Task<IEnumerable<Matches>> GetAllAsync();
        Task<IEnumerable<Matches>> GetRoomsByStatusAsync(MatchStatus status);
        Task<IEnumerable<Matches>> GetRoomsByFormatAsync(MatchFormat format);
        Task<IEnumerable<Matches>> GetRoomsByCategoryAsync(MatchCategory category);
        Task<IEnumerable<Matches>> GetRoomsByWinScoreAsync(WinScore winScore);
        Task<IEnumerable<Matches>> GetRoomsByVenueIdAsync(int venueId);
        Task<IEnumerable<Matches>> GetRoomsByRefereeIdAsync(int refereeId);
        Task<IEnumerable<Matches>> GetRoomsByDateRangeAsync(DateTime startDate, DateTime endDate);
        Task<IEnumerable<Matches>> GetRoomsByPublicStatusAsync(bool isPublic);
    }
}
