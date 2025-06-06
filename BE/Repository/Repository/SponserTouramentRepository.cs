using Database.Model;
using Database.Model.Dbcontext;
using Microsoft.EntityFrameworkCore;
using Repository.Repository.Interfeace;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Repository.Repository
{
    public class SponserTouramentRepository : BaseRepository<SponnerTourament>,ISponserTouramentRepository
    {
        private readonly PickerBallDbcontext _context;
        public SponserTouramentRepository(PickerBallDbcontext context) : base(context)
        {
            _context = context;
        }

        public async Task<List<SponnerTourament>> GetAllSponnerByTouramentId(int touramentId)
        {
            return await _context.sponnerTouraments.Where(x => x.TournamentId == touramentId).Include( s => s.Sponsor).ToListAsync();
        }

        public Task<List<SponnerTourament>> GetAllTouramentBySponnerId(int sponserId)
        {
            return _context.sponnerTouraments.Where(x => x.SponsorId == sponserId).ToListAsync();
        }
    }
}
