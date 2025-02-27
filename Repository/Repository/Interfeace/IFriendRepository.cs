using Database.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Repository.Repository.Interfeace
{
    public interface IFriendRepository : IBaseRepository<Friends>
    {
        Task<List<Friends>> getFriendByUserId(int UserId);
        Task<List<Friends>> getFriendResponseByUserId(int UserId);
        Task<List<Friends>> GetFriendsAsync(int userId);
    }
}
