using Database.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Repository.Repository.Interfeace
{
    public interface ITouramentMatchesRepository : IBaseRepository<TouramentMatches>
    {
        Task<List<TouramentMatches>> getMatchByTouramentId(int TouramentId);
        Task<List<TouramentMatches>> getByMatchId(int MatchId);

    }
}
