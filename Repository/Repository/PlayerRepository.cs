using Database.Model;
using Database.Model.Dbcontext;
using Microsoft.EntityFrameworkCore;
using Repository.Repository.Interfeace;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Database.DTO.Request;

namespace Repository.Repository
{
    public class PlayerRepository : BaseRepository<Player>, IPlayerRepository
    {

        private readonly PickerBallDbcontext _context;
        public PlayerRepository(PickerBallDbcontext context) : base(context)
        {
            _context = context;
        }

        public async Task<Player> CreatePlayer(Player player)
        {
            await _context.Player.AddAsync(player);
            await _context.SaveChangesAsync();
            return player;
        }

        public async Task<List<Player>> GetAllPlayer()
        {
            return await _context.Player.ToListAsync();
        }

        public async Task<Player> GetPlayerById(int playerId)
        {
            return await _context.Player.FirstOrDefaultAsync(x => x.PlayerId == playerId);
        }

        public async Task<Player> UpdatePlayer(Player player)
        {
            _context.Player.Update(player);
            await _context.SaveChangesAsync();
            return player;
        }
    }
}
