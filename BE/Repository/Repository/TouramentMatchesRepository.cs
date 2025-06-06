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
    public class TouramentMatchesRepository : BaseRepository<TouramentMatches>, ITouramentMatchesRepository
    {
        private readonly PickerBallDbcontext _context;
        public TouramentMatchesRepository(PickerBallDbcontext context) : base(context)
        {
            _context = context;
        }

        public async Task<List<TouramentMatches>> getByMatchId(int MatchId)
        {
            return await _context.TouramentMatches.Where(x => x.MatchesId == MatchId).ToListAsync();
        }
        public async Task<List<TouramentMatches>> getMatchByTouramentId(int TouramentId)
        {
            return await _context.TouramentMatches.Where(x => x.TournamentId == TouramentId).ToListAsync();
        }
    }
}
