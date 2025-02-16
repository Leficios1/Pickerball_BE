using Database.Model;
using System.Collections.Generic;
using System.Threading.Tasks;
using Repository.Repository.Interfeace;

namespace Repository.Repository.Interface
{
    public interface IMatchesRepository : IBaseRepository<Matches>
    {
        Task<IEnumerable<Matches>> GetAllAsync();
        Task<Matches?> GetByIdAsync(int id);
    }
}