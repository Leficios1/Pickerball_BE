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
    public class VenuesRepository : BaseRepository<Venues>, IVenusRepository
    {
        private readonly PickerBallDbcontext _context;

        public VenuesRepository(PickerBallDbcontext context) : base(context)
        {
            _context = context;
        }

        public async Task<List<Venues>> GetVenuesByCreateByAsync(int createBy)
        {
            return await _context.Venues
                .Where(v => v.CreateBy == createBy)
                .ToListAsync();
        }
    }
}
