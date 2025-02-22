using Database.Model;
using System.Threading.Tasks;
using Repository.Repository.Interfeace;

namespace Repository.Repository.Interface
{
    public interface ITeamRepository : IBaseRepository<Team>
    {
        Task<Team?> GetTeamWithMembersAsync(int teamId);
        Task<List<Team>> GetTeamWithMatchingIdAsync(int matchingId);
    }
}
