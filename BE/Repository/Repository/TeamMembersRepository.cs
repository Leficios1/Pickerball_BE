using Database.Model;
using Database.Model.Dbcontext;
using Microsoft.EntityFrameworkCore;
using Repository.Repository.Interface;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Database.DTO.Response;

namespace Repository.Repository
{
    public class TeamMembersRepository : BaseRepository<TeamMembers>, ITeamMembersRepository
    {
        private readonly PickerBallDbcontext _context;

        public TeamMembersRepository(PickerBallDbcontext context) : base(context)
        {
            _context = context;
        }

        public async Task<IEnumerable<TeamMembers>> GetByTeamIdAsync(int teamId)
        {
            return await _context.TeamMembers
                .Where(tm => tm.TeamId == teamId)
                .ToListAsync();
        }

        public async Task<IEnumerable<TeamMembers>> GetByPlayerIdAsync(int playerId)
        {
            return await _context.TeamMembers
                .Where(tm => tm.PlayerId == playerId)
                .ToListAsync();
        }

        public async Task<TeamMembers> GetByPlayerIdAndTeamIdAsync(int playerId, int teamId)
        {
            return await _context.TeamMembers
                .Where(tm => tm.PlayerId == playerId && tm.TeamId == teamId)
                .FirstOrDefaultAsync();
        }
    }
}
