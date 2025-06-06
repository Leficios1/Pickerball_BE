using Database.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Repository.Repository.Interfeace
{
    public interface ISponserTouramentRepository : IBaseRepository<SponnerTourament>
    {
        Task<List<SponnerTourament>> GetAllTouramentBySponnerId(int sponserId);
        Task<List<SponnerTourament>> GetAllSponnerByTouramentId(int touramentId);
    }
}
