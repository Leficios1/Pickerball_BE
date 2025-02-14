using Database.Model;
using Database.Model.Dbcontext;
using Microsoft.EntityFrameworkCore;
using Repository.Repository.Interface;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Repository.Repository
{
    public class TeamRepository : BaseRepository<Team>, ITeamRepository
    {
        private readonly PickerBallDbcontext _context;

        public TeamRepository(PickerBallDbcontext context) : base(context)
        {
            _context = context;
        }

        public async Task<Team?> GetTeamWithMembersAsync(int teamId)
        {
            return await _context.Teams
                .Include(t => t.Members)
                .ThenInclude(m => m.Playermember)
                .FirstOrDefaultAsync(t => t.Id == teamId);
        }

        public async Task<Team?> GetByIdAsync(int id)
        {
            return await _context.Teams.FindAsync(id);
        }

        public async Task<List<Team>> GetTeamsWithMatchingIdAsync(int matchingId)
        {
            return await _context.Teams
                .Include(t => t.Members)
                .ThenInclude(m => m.Playermember)
                .Where(t => t.MatchingId == matchingId)
                .ToListAsync();
        }
    }
}