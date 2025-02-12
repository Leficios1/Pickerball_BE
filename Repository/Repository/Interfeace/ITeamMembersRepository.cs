using Database.Model;
using System.Collections.Generic;
using System.Threading.Tasks;
using Repository.Repository.Interfeace;

namespace Repository.Repository.Interface
{
    public interface ITeamMembersRepository : IBaseRepository<TeamMembers>
    {
        Task<IEnumerable<TeamMembers>> GetByTeamIdAsync(int teamId);
        Task<IEnumerable<TeamMembers>> GetByPlayerIdAsync(int playerId); // Add this method
        Task AddAsync(TeamMembers teamMember); // Add this method
    }
}