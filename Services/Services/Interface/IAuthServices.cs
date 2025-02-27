using Database.DTO.Request;
using Database.DTO.Response;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Services.Services.Interface
{
    public interface IAuthServices
    {
        public Task<StatusResponse<TokenReponse>> LoginAccount(AuthRequestDTO dto);
        public Task<StatusResponse<UserResponseDTO>> RegisterAsync(UserRegisterRequestDTO dto);
        public Task<StatusResponse<RefershTokenResponseDTO>> getRefershToken(RefershTokenRequestDTO dto);
        public Task<UserResponseDTO> GetUserByToken(string token);

        public Task<StatusResponse<UserResponseDTO>> RefereeRegisterAsync(UserRegisterRequestDTO dto);
    }
}
