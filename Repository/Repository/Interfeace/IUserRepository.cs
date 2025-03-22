using Database.DTO.Response;
using Database.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Repository.Repository.Interfeace
{
    public interface IUserRepository : IBaseRepository<User>
    {
        Task<User?> GetByEmailAsync(string email);
        Task<List<User>> GetAllUser();
        Task<User> GetUserByIdAsync(int userId);
        Task<User> UpdateUserAsync(User user);
        Task<User> GetUserByRefershToken(string RefershToken);
        Task<List<User>> GetAllRefeeUserAsync();
        Task<List<User>> GetAllOrganizerUserAsync();
        Task<List<User>> GetAllStaffUserAsync();
    }
}
