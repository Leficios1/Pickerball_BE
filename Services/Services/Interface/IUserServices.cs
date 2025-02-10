using Database.DTO.Request;
using Database.DTO.Response;
using Database.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Services.Services.Interface
{
    public interface IUserServices
    {
        public bool VerifyPassword(User user, string password);
        public string HashPassword(User user, string password);
        public StatusResponse<bool> registerUser(UserRegisterRequestDTO dto);
    }
}
