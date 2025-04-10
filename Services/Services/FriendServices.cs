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
        private readonly INotificationRepository _notificationRepository;
        private readonly IUserRepository _userRepository;
        private readonly IMapper _mapper;

        public FriendServices(IFriendRepository friendRepository, IMapper mapper, INotificationRepository notificationRepository, IUserRepository userRepository)
        {
            _friendRepository = friendRepository;
            _notificationRepository = notificationRepository;
            _userRepository = userRepository;
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
                var dataUser = await _userRepository.GetById(dto.User2Id);
                var notification = new Notification
                {
                    UserId = dto.User1Id,
                    Message = $"{dataUser.LastName} accepted your friend request",
                    CreatedAt = DateTime.UtcNow,
                    IsRead = false,
                    Type = NotificationType.FriendRequest,
                    ReferenceId = dto.User1Id // Assuming ReferenceId is the ID of the user who sent the request
                };
                await _notificationRepository.AddAsync(notification);
                friend.Status = FriendStatus.Accepted;
                _friendRepository.Update(friend);
                await _friendRepository.SaveChangesAsync();
                await _notificationRepository.SaveChangesAsync();
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
                    var dataUser = await _userRepository.GetById(friend.User1Id);
                    if (dataUser == null)
                    {
                        response.Message = "User not found";
                        response.statusCode = System.Net.HttpStatusCode.NotFound;
                        return response;
                    }

                    await _friendRepository.AddAsync(friend);
                    await _friendRepository.SaveChangesAsync();
                    var notification = new Notification
                    {
                        UserId = friend.User2Id,
                        Message = $"{dataUser.LastName} sent you a friend request",
                        CreatedAt = DateTime.UtcNow,
                        IsRead = false,
                        Type = NotificationType.FriendRequest,
                        ReferenceId = friend.User1Id // Assuming ReferenceId is the ID of the user who sent the request
                    };
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
                    UserFriendName = f.User1Id == userId
    ? (f.User2 != null ? f.User2.FirstName + " " + f.User2.LastName : "Unknown")
    : (f.User1 != null ? f.User1.FirstName + " " + f.User1.LastName : "Unknown"),

                    UserFriendAvatar = f.User1Id == userId
    ? (f.User2?.AvatarUrl ?? "")
    : (f.User1?.AvatarUrl ?? ""),
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

        public async Task<StatusResponse<List<FriendResponseDTO>>> GetFriends(int userId, string? Gender, int? MinLevel, int? MaxLevel)
        {
            var response = new StatusResponse<List<FriendResponseDTO>>();
            try
            {
                var friendships = await _friendRepository.GetFriendsAsync(userId);

                if (friendships == null || !friendships.Any())
                {
                    return new StatusResponse<List<FriendResponseDTO>>
                    {
                        statusCode = HttpStatusCode.NotFound,
                        Message = "No friends found.",
                        Data = new List<FriendResponseDTO>()
                    };
                }

                // Áp dụng filter nếu có
                var filteredFriends = friendships.Where(f =>
                {
                    var friendUser = f.User1Id == userId ? f.User2 : f.User1;

                    if (!string.IsNullOrEmpty(Gender) && !string.Equals(friendUser.Gender, Gender, StringComparison.OrdinalIgnoreCase))
                        return false;

                    if (MinLevel.HasValue && friendUser.Player.ExperienceLevel < MinLevel.Value)
                        return false;

                    if (MaxLevel.HasValue && friendUser.Player.ExperienceLevel > MaxLevel.Value)
                        return false;

                    return true;
                }).ToList();

                var result = filteredFriends.Select(f =>
                {
                    var friendUser = f.User1Id == userId ? f.User2 : f.User1;

                    return new FriendResponseDTO
                    {
                        Id = f.Id,
                        User1Id = f.User1Id,
                        User2Id = f.User2Id,
                        UserFriendId = friendUser.Id,
                        UserFriendName = $"{friendUser.FirstName} {friendUser.LastName}",
                        UserFriendAvatar = friendUser.AvatarUrl,
                        Status = f.Status,
                        CreatedAt = f.CreatedAt,
                        Gender = friendUser.Gender,
                        ExeprienceLevel = friendUser.Player.ExperienceLevel
                    };
                }).ToList();

                response.Data = result;
                response.Message = "Friends fetched successfully";
                response.statusCode = HttpStatusCode.OK;
            }
            catch (Exception e)
            {
                response.Message = e.Message;
                response.statusCode = HttpStatusCode.InternalServerError;
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
