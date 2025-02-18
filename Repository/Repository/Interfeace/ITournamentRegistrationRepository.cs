using Database.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Repository.Repository.Interfeace
{
    public interface ITournamentRegistrationRepository : IBaseRepository<TournamentRegistration>
    {
        Task<List<TournamentRegistration>> getByTournamentId(int TournamentId);
    }
}
