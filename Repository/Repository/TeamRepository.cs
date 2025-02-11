using Database.Model;
using Database.Model.Dbcontext;
using Microsoft.EntityFrameworkCore;
using Repository.Repository.Interface;
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
    }
}
