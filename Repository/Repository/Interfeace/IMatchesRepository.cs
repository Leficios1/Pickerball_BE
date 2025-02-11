using Database.Model;
using System.Threading.Tasks;

namespace Repository.Repository.Interfeace
{
    public interface IMatchesRepository : IBaseRepository<Matches>
    {
        // Additional methods specific to Matches can be added here
        Task<IEnumerable<Matches>> GetAllAsync();
        Task<Matches> GetByIdAsync(int id);
    }
}