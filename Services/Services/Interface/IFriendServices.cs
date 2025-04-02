using Database.DTO.Request;
using Database.DTO.Response;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Services.Services.Interface
{
    public interface IFriendServices
    {
        Task<StatusResponse<FriendResponseDTO>> AddFriend(FriendRequestDTO dto);
        Task<StatusResponse<bool>> RemoveFriend(FriendRequestDTO dto);
        Task<StatusResponse<List<FriendResponseDTO>>> GetFriends(int userId, string? Gender, int? MinLevel, int? MaxLevel);
        Task<StatusResponse<List<FriendResponseDTO>>> GetFriendRequests(int userId);
        Task<StatusResponse<bool>> AcceptFriendRequest(FriendRequestDTO dto);
    }
}
