using AutoMapper;
using Database.DTO.Request;
using Database.DTO.Response;
using Database.Model;
using Repository.Repository.Interfeace;
using Services.Services.Interface;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;
using System.Transactions;

namespace Services.Services
{
    public class FriendServices : IFriendServices
    {
        private readonly IFriendRepository _friendRepository;
        private readonly IMapper _mapper;

        public FriendServices(IFriendRepository friendRepository, IMapper mapper)
        {
            _friendRepository = friendRepository;
            _mapper = mapper;
        }

        public async Task<StatusResponse<bool>> AcceptFriendRequest(FriendRequestDTO dto)
        {
            var response = new StatusResponse<bool>();
            try
            {
                var data = await _friendRepository.getFriendResponseByUserId(dto.User1Id);
                var friend = data.FirstOrDefault(x => x.User1Id == dto.User2Id && x.User2Id == dto.User1Id);
                if (friend == null)
                {
                    response.Data = false;
                    response.Message = "Friend Request not found";
                    response.statusCode = System.Net.HttpStatusCode.NotFound;
                    return response;
                }
                friend.Status = FriendStatus.Accepted;
                _friendRepository.Update(friend);
                await _friendRepository.SaveChangesAsync();
                response.Data = true;
                response.Message = "Friend request accepted successfully";
                response.statusCode = System.Net.HttpStatusCode.OK;
            }
            catch (Exception e)
            {
                response.Message = e.Message;
                response.statusCode = System.Net.HttpStatusCode.InternalServerError;
            }
            return response;
        }

        public async Task<StatusResponse<FriendResponseDTO>> AddFriend(FriendRequestDTO dto)
        {
            var response = new StatusResponse<FriendResponseDTO>();
            using (var transaction = new TransactionScope(TransactionScopeAsyncFlowOption.Enabled))
                try
                {
                    var friend = _mapper.Map<Friends>(dto);
                    friend.Status = FriendStatus.Pending;
                    friend.CreatedAt = DateTime.UtcNow;
                    var check = await _friendRepository.getFriendResponseByUserId(friend.User2Id);
                    if (check.Any())
                    {
                        var data = check.SingleOrDefault(x => x.User1Id == friend.User2Id && x.User2Id == friend.User1Id);
                        if (data != null && data.Status == FriendStatus.Accepted)
                        {
                            response.Message = "Friend already exists";
                            response.statusCode = System.Net.HttpStatusCode.BadRequest;
                            return response;
                        }
                        else if (data != null && data.Status == FriendStatus.Pending)
                        {
                            data.Status = FriendStatus.Accepted;
                            response.Message = "Friend request already sent and change to Accepted";
                            response.statusCode = System.Net.HttpStatusCode.OK;
                            return response;
                        }
                        else if (data != null && data.Status == FriendStatus.Blocked)
                        {
                            response.Message = "this friend is blocked";
                            response.statusCode = System.Net.HttpStatusCode.BadRequest;
                            return response;
                        }
                    }
                    await _friendRepository.AddAsync(friend);
                    await _friendRepository.SaveChangesAsync();
                    transaction.Complete();
                    response.Data = _mapper.Map<FriendResponseDTO>(friend);
                    response.Message = "Friend added successfully";
                    response.statusCode = System.Net.HttpStatusCode.OK;
                }
                catch (Exception e)
                {
                    response.Message = e.Message;
                    response.statusCode = System.Net.HttpStatusCode.InternalServerError;
                }
            return response;
        }

        public async Task<StatusResponse<List<FriendResponseDTO>>> GetFriendRequests(int userId)
        {
            var response = new StatusResponse<List<FriendResponseDTO>>();
            try
            {
                var friendships = await _friendRepository.getFriendResponseByUserId(userId);
                var friendRequests = friendships.Where(x => x.Status == FriendStatus.Pending).ToList();
                var result = friendships.Select(f => new FriendResponseDTO
                {
                    Id = f.Id,
                    User1Id = f.User1Id,
                    User2Id = f.User2Id,
                    UserFriendId = f.User1Id == userId ? f.User2Id : f.User1Id,
                    UserFriendName = f.User1Id == userId ? f.User2.FirstName + " " + f.User2.LastName : f.User1.FirstName + " " + f.User1.LastName,
                    UserFriendAvatar = f.User1Id == userId ? f.User2.AvatarUrl : f.User1.AvatarUrl,
                    Status = f.Status,
                    CreatedAt = f.CreatedAt
                }).ToList();


                response.Data = result;
                response.Message = "Friend requests fetched successfully";
                response.statusCode = System.Net.HttpStatusCode.OK;
            }
            catch (Exception e)
            {
                response.Message = e.Message;
                response.statusCode = System.Net.HttpStatusCode.InternalServerError;
            }
            return response;
        }

        public async Task<StatusResponse<List<FriendResponseDTO>>> GetFriends(int userId)
        {
            var response = new StatusResponse<List<FriendResponseDTO>>();
            try
            {
                var friendships = await _friendRepository.GetFriendsAsync(userId);
                if (friendships == null || !friendships.Any())
                {
                    response.statusCode = HttpStatusCode.NotFound;
                    response.Message = "No friends found.";
                    return response;
                }

                var result = friendships.Select(f => new FriendResponseDTO
                {
                    Id = f.Id,
                    User1Id = f.User1Id,
                    User2Id = f.User2Id,
                    UserFriendId = f.User1Id == userId ? f.User2Id : f.User1Id,
                    UserFriendName = f.User1Id == userId ? f.User2.FirstName + " " + f.User2.LastName : f.User1.FirstName + " " + f.User1.LastName,
                    UserFriendAvatar = f.User1Id == userId ? f.User2.AvatarUrl : f.User1.AvatarUrl,
                    Status = f.Status,
                    CreatedAt = f.CreatedAt
                }).ToList();
                response.Data = result;
                response.Message = "Friends fetched successfully";
                response.statusCode = System.Net.HttpStatusCode.OK;
            }
            catch (Exception e)
            {
                response.Message = e.Message;
                response.statusCode = System.Net.HttpStatusCode.InternalServerError;
            }
            return response;
        }

        public async Task<StatusResponse<bool>> RemoveFriend(FriendRequestDTO dto)
        {
            var response = new StatusResponse<bool>();
            using (var transaction = new TransactionScope(TransactionScopeAsyncFlowOption.Enabled))
                try
                {
                    var data = await _friendRepository.getFriendByUserId(dto.User1Id);
                    var friend = data.FirstOrDefault(x => x.User1Id == dto.User1Id && x.User2Id == dto.User2Id);
                    if (friend == null)
                    {
                        response.Data = false;
                        response.Message = "Friend not found";
                        response.statusCode = System.Net.HttpStatusCode.NotFound;
                        return response;
                    }
                    _friendRepository.Delete(friend);
                    await _friendRepository.SaveChangesAsync();
                    transaction.Complete();
                    response.Data = true;
                    response.Message = "Friend removed successfully";
                    response.statusCode = System.Net.HttpStatusCode.OK;
                }
                catch (Exception e)
                {
                    response.Message = e.Message;
                    response.statusCode = System.Net.HttpStatusCode.InternalServerError;
                }
            return response;
        }
    }
}
