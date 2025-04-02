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
        public Task<StatusResponse<List<UserResponseDTO>>> getAllUser(int? PageNumber, int?Pagesize, bool isOrderbyCreateAt);
        public Task<StatusResponse<UserResponseDTO>> getUserById(int UserId);
        public Task<StatusResponse<UserResponseDTO>> UpdateUser(UserUpdateRequestDTO dto, int id);
        public Task<StatusResponse<bool>> DeletedUser(int UserId);
        public Task<StatusResponse<bool>> AcceptUser(int sponserId);
        public Task<StatusResponse<Refree>> CreateReferee(RefereeCreateRequestDTO dto);
        public Task<StatusResponse<List<UserResponseDTO>>> getAllRefeeUser();
        public Task<StatusResponse<List<UserResponseDTO>>> getAllPlayerUser();

    }
}
