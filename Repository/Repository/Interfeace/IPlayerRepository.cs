using Database.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Repository.Repository.Interfeace
{
    public interface IPlayerRepository : IBaseRepository<Player>
    {
        Task<Player> CreatePlayer(Player player);
        Task<Player> GetPlayerById(int playerId);
        Task<List<Player>> GetAllPlayer();
        Task<Player> UpdatePlayer(Player player);
    }
}
