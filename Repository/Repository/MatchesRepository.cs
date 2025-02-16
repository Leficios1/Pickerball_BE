using Database.Model;
using Database.Model.Dbcontext;
using Microsoft.EntityFrameworkCore;
using Repository.Repository.Interface;
using System.Collections.Generic;
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

    }
}
