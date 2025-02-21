using Database.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Repository.Repository.Interfeace
{
    public interface ISponsorRepository : IBaseRepository<Sponsor>
    {
        Task<List<Sponsor>> GetAllSponsorsOrderedByCreateAtAsync();
    }
}
