using Database.Model;
using Database.Model.Dbcontext;
using Microsoft.EntityFrameworkCore;
using Repository.Repository.Interfeace;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Repository.Repository
{
    public class FriendRepository : BaseRepository<Friends>, IFriendRepository
    {
        private readonly PickerBallDbcontext _context;
        public FriendRepository(PickerBallDbcontext context) : base(context)
        {
            _context = context;
        }

        public async Task<List<Friends>> getFriendByUserId(int UserId)
        {
            return await _context.Friends.Where(x => x.User1Id == UserId).ToListAsync();
        }

        public async Task<List<Friends>> getFriendResponseByUserId(int UserId)
        {
            return await _context.Friends.Where(x => x.User2Id == UserId).Include(x => x.User1).ToListAsync();
        }

        public async Task<List<Friends>> GetFriendsAsync(int userId)
        {
            return await _context.Friends
                .Where(f => f.Status == FriendStatus.Accepted && (f.User1Id == userId || f.User2Id == userId))
                .Include(f => f.User2).ThenInclude(u => u.Player)
                .Include(f => f.User1).ThenInclude(u => u.Player)
                .ToListAsync();
        }
    }
}
