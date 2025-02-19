using Database.Model;
using Database.Model.Dbcontext;
using Microsoft.EntityFrameworkCore;
using Repository.Repository.Interface;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Repository.Repository
{
    public class MatchesRepository : BaseRepository<Matches>, IMatchesRepository
    {
        private readonly PickerBallDbcontext _context;

        public MatchesRepository(PickerBallDbcontext context) : base(context)
        {
            _context = context;
        }

        public async Task<IEnumerable<Matches>> GetAllAsync()
        {
            return await _context.Matches.ToListAsync();
        }

        public async Task<Matches> GetByIdAsync(int id)
        {
            return await _context.Matches.FindAsync(id);
        }

        public async Task<IEnumerable<Matches>> GetPublicRoomsAsync()
        {
            return await _context.Matches.Where(m => m.IsPublic).ToListAsync();
        }

        public async Task<IEnumerable<Matches>> GetRoomsByStatusAsync(MatchStatus status)
        {
            return await _context.Matches.Where(m => m.Status == status).ToListAsync();
        }

        public async Task<IEnumerable<Matches>> GetRoomsByFormatAsync(MatchFormat format)
        {
            return await _context.Matches.Where(m => m.MatchFormat == format).ToListAsync();
        }

        public async Task<IEnumerable<Matches>> GetRoomsByCategoryAsync(MatchCategory category)
        {
            return await _context.Matches.Where(m => m.MatchCategory == category).ToListAsync();
        }

        public async Task<IEnumerable<Matches>> GetRoomsByWinScoreAsync(WinScore winScore)
        {
            return await _context.Matches.Where(m => m.WinScore == winScore).ToListAsync();
        }

        public async Task<IEnumerable<Matches>> GetRoomsByVenueIdAsync(int venueId)
        {
            return await _context.Matches.Where(m => m.VenueId == venueId).ToListAsync();
        }

        public async Task<IEnumerable<Matches>> GetRoomsByRefereeIdAsync(int refereeId)
        {
            return await _context.Matches.Where(m => m.RefereeId == refereeId).ToListAsync();
        }

        public async Task<IEnumerable<Matches>> GetRoomsByDateRangeAsync(DateTime startDate, DateTime endDate)
        {
            return await _context.Matches.Where(m => m.MatchDate >= startDate && m.MatchDate <= endDate).ToListAsync();
        }

        public async Task<IEnumerable<Matches>> GetRoomsByPublicStatusAsync(bool isPublic)
        {
            return await _context.Matches.Where(m => m.IsPublic == isPublic).ToListAsync();
        }
    }
}