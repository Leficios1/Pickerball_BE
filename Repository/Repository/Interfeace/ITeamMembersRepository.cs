using Database.Model;
using System.Collections.Generic;
using System.Threading.Tasks;
using Database.DTO.Response;
using Repository.Repository.Interfeace;

namespace Repository.Repository.Interface
{
    public interface ITeamMembersRepository : IBaseRepository<TeamMembers>
    {
        Task<IEnumerable<TeamMembers>> GetByTeamIdAsync(int teamId);
        Task<IEnumerable<TeamMembers>> GetByPlayerIdAsync(int playerId);
        Task<TeamMembers> GetByPlayerIdAndTeamIdAsync(int playerId, int teamId);
    }
}