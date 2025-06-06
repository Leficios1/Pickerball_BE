using Database.Model;
using Database.Model.Dbcontext;
using Repository.Repository.Interfeace;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;

namespace Repository.Repository
{
    public class SponsorRepository : BaseRepository<Sponsor>, ISponsorRepository
    {
        private readonly PickerBallDbcontext _context;
        public SponsorRepository(PickerBallDbcontext context) : base(context)
        {
            _context = context;
        }
        
        public async Task<List<Sponsor>> GetAllSponsorsOrderedByCreateAtAsync()
        {
            return await _context.Sponsors
                .OrderByDescending(s => s.JoinedAt)
                .ToListAsync();
        }
    }
}
