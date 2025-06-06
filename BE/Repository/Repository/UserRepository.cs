using Database.DTO.Response;
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
    public class UserRepository : BaseRepository<User>, IUserRepository
    {
        private readonly PickerBallDbcontext _context;

        public UserRepository(PickerBallDbcontext context) : base(context)
        {
            _context = context;
        }

        public async Task<List<Refree>> GetAllRefeeUserAsync()
        {
            return await _context.Refree.Include(x => x.User).ToListAsync();
        }

        public async Task<List<User>> GetAllUser()
        {
            return await _context.Users.ToListAsync();
        }

        public async Task<User?> GetByEmailAsync(string email)
        {
            return await _context.Set<User>().FirstOrDefaultAsync(u => u.Email == email);
        }

        public async Task<User> GetUserByIdAsync(int userId)
        {
            return await _context.Users.Where(u => u.Id == userId).SingleOrDefaultAsync();
        }

        public async Task<User> GetUserByRefershToken(string RefershToken)
        {
            return await _context.Users.Where(u => u.RefreshToken.Equals(RefershToken)).SingleOrDefaultAsync();
        }

        public async Task<User> UpdateUserAsync(User user)
        {
            var existingUser = await _context.Users.FindAsync(user.Id);

            if (existingUser == null)
                throw new Exception("User not found");

            _context.Entry(existingUser).CurrentValues.SetValues(user);

            await _context.SaveChangesAsync();
            return existingUser;
        }
    }
}
