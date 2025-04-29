
using AutoMapper;
using Database.DTO.Request;
using Database.DTO.Response;
using Database.Model;
using Microsoft.AspNetCore.Http.HttpResults;
using Microsoft.AspNetCore.Mvc.Filters;
using Microsoft.EntityFrameworkCore;
using Repository.Repository.Interface;
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
    public class MatchSentRequestServices : IMatchSentRequestServices
    {
        private readonly IMatchSentRequestRepository _matchSentRequestRepository;
        private readonly IPlayerRepository _playerRepository;
        private readonly IMatchesRepository _matchRepository;
        private readonly IMapper _mapper;
        private readonly ITeamMembersRepository _membersRepository;
        private readonly ITeamRepository _teamRepository;
        private readonly ITeamMembersRepository _teamMembersRepository;
        private readonly IUserRepository _userRepository;
        private readonly INotificationRepository _notificationRepository;

        public MatchSentRequestServices(IMatchSentRequestRepository matchSentRequestRepository, IPlayerRepository playerRepository, IMatchesRepository matchRepository,
            IMapper mapper, ITeamMembersRepository membersRepository, ITeamRepository teamRepository, ITeamMembersRepository teamMembersRepository, IUserRepository userRepository,
            INotificationRepository notificationRepository)
        {
            _matchSentRequestRepository = matchSentRequestRepository;
            _playerRepository = playerRepository;
            _matchRepository = matchRepository;
            _mapper = mapper;
            _membersRepository = membersRepository;
            _teamRepository = teamRepository;
            _teamMembersRepository = teamMembersRepository;
            _userRepository = userRepository;
            _notificationRepository = notificationRepository;
        }


        public async Task<StatusResponse<MatchSentRequestResponseDTO>> AcceptRequest(int RequestId, int UserAcceptId, SendRequestStatus Accpet)
        {
            var response = new StatusResponse<MatchSentRequestResponseDTO>();
            using (var transaction = new TransactionScope(TransactionScopeAsyncFlowOption.Enabled))
                try
                {
                    var data = await _matchSentRequestRepository.GetById(RequestId);
                    if (data == null)
                    {
                        response.Message = "Request not found!";
                        response.statusCode = HttpStatusCode.NotFound;
                        return response;
                    }
                    if (data.PlayerRecieveId != UserAcceptId)
                    {
                        response.Message = "You are not the user accept this request!";
                        response.statusCode = HttpStatusCode.Forbidden;
                        return response;
                    }
                    var match = await _matchRepository.GetById(data.MatchingId);
                    if (match == null)
                    {
                        response.Message = "Match not found!";
                        response.statusCode = HttpStatusCode.NotFound;
                        return response;
                    }
                    var teams = await _teamRepository.GetTeamsWithMatchingIdAsync(match.Id);
                    if (teams == null || teams.Count < 2)
                    {
                        response.Message = "Teams not found for this match!";
                        response.statusCode = HttpStatusCode.NotFound;
                        return response;
                    }

                    // 🔥 Kiểm tra số lượng thành viên hiện tại
                    int totalPlayers = teams.Sum(t => t.Members.Count);
                    var maxPlayers = 2;
                    if (match.MatchFormat == MatchFormat.DoubleFemale || match.MatchFormat == MatchFormat.DoubleMale || match.MatchFormat == MatchFormat.DoubleMix)
                    {
                        maxPlayers = 4;
                    }

                    if (totalPlayers >= maxPlayers)
                    {
                        data.status = SendRequestStatus.Reject;
                        data.LastUpdatedAt = DateTime.UtcNow;
                        _matchSentRequestRepository.Update(data);
                        await _matchSentRequestRepository.SaveChangesAsync();
                        response.Message = "Match is full!";
                        response.statusCode = HttpStatusCode.BadRequest;
                        transaction.Complete();
                        return response; // 🚨 Trả về ngay nếu trận đã full
                    }
                    if (Accpet == SendRequestStatus.Accept)
                    {
                        data.status = Accpet;
                        data.LastUpdatedAt = DateTime.UtcNow;

                        bool isAlreadyInMatch = teams.Any(t => t.Members.Any(m => m.PlayerId == UserAcceptId));
                        if (isAlreadyInMatch)
                        {
                            response.Message = "Player already in match";
                            response.statusCode = HttpStatusCode.BadRequest;
                            return response;
                        }
                        // 🔥 Xử lý cập nhật Team
                        await ProcessTeamUpdate(teams, UserAcceptId, match.MatchFormat);

                        // 🔥 Cập nhật trạng thái Request & từ chối request khác
                        await RejectOtherRequests(UserAcceptId, RequestId);

                        _matchSentRequestRepository.Update(data);
                        await _matchSentRequestRepository.SaveChangesAsync();
                        _matchSentRequestRepository.Update(data);
                        await _matchSentRequestRepository.SaveChangesAsync();
                    }
                    else if (Accpet == SendRequestStatus.Reject)
                    {
                        data.status = Accpet;
                        data.LastUpdatedAt = DateTime.UtcNow;
                        _matchSentRequestRepository.Update(data);
                        await _matchSentRequestRepository.SaveChangesAsync();
                    }


                    response.Data = new MatchSentRequestResponseDTO
                    {
                        Id = data.Id,
                        MatchingId = data.MatchingId,
                        PlayerRequestId = data.PlayerRequestId,
                        PlayerRecieveId = data.PlayerRecieveId,
                        status = data.status,
                        LastUpdatedAt = data.LastUpdatedAt
                    };
                    var dataUser = await _userRepository.GetById(data.PlayerRecieveId);
                    var notification = new Notification()
                    {
                        UserId = data.PlayerRequestId,
                        Message = $"{dataUser.LastName} accepted your match request",
                        CreatedAt = DateTime.UtcNow,
                        IsRead = false,
                        Type = NotificationType.AcceptMatchRequest,
                        ReferenceId = data.MatchingId
                    };
                    await _notificationRepository.AddAsync(notification);
                    await _notificationRepository.SaveChangesAsync();

                    response.Message = "Request accepted and team created successfully!";
                    response.statusCode = HttpStatusCode.OK;
                    transaction.Complete();
                }
                catch (Exception ex)
                {
                    response.Message = ex.Message;
                    response.statusCode = HttpStatusCode.InternalServerError;
                }
            return response;
        }
        internal async Task ProcessTeamUpdate(List<Team> teams, int UserAcceptId, MatchFormat format)
        {
            foreach (var team in teams)
            {
                if (team.CaptainId == null)
                {
                    team.CaptainId = UserAcceptId;
                    var teamMember = new TeamMembers
                    {
                        TeamId = team.Id,
                        PlayerId = UserAcceptId,
                        JoinedAt = DateTime.UtcNow
                    };
                    _teamRepository.Update(team);
                    await _teamMembersRepository.AddAsync(teamMember);
                    await _teamMembersRepository.SaveChangesAsync();
                    await _teamRepository.SaveChangesAsync();
                    return;
                }
            }

            foreach (var team in teams)
            {
                //Sửa lại
                if (team.Members.Count < (format == MatchFormat.DoubleMale ||
                                          format == MatchFormat.DoubleFemale ||
                                          format == MatchFormat.DoubleMix ? 2 : 1))
                {
                    var teamMember = new TeamMembers
                    {
                        TeamId = team.Id,
                        PlayerId = UserAcceptId,
                        JoinedAt = DateTime.UtcNow
                    };

                    await _teamMembersRepository.AddAsync(teamMember);
                    await _teamMembersRepository.SaveChangesAsync();
                    return;
                }
            }
        }
        internal async Task RejectOtherRequests(int UserAcceptId, int RequestId)
        {
            var otherRequests = await _matchSentRequestRepository.GetByReceviedId(UserAcceptId);
            foreach (var request in otherRequests)
            {
                if (request.Id != RequestId)
                {
                    request.status = SendRequestStatus.Reject;
                    _matchSentRequestRepository.Update(request);
                }
            }
            await _matchSentRequestRepository.SaveChangesAsync();
        }

        public async Task<StatusResponse<List<MatchSentRequestResponseDTO>>> getAll()
        {
            var response = new StatusResponse<List<MatchSentRequestResponseDTO>>();
            try
            {
                var data = await _matchSentRequestRepository.GetAll();
                var mapper = _mapper.Map<List<MatchSentRequestResponseDTO>>(data);
                response.Data = mapper;
                response.statusCode = HttpStatusCode.OK;
                response.Message = "Get all request successfully!";
            }
            catch (Exception ex)
            {
                response.Message = ex.Message;
                response.statusCode = HttpStatusCode.InternalServerError;
            }
            return response;
        }

        public async Task<StatusResponse<List<MatchSentRequestResponseDTO>>> GetByUserSendRequestId(int UserSendRequestId)
        {
            var response = new StatusResponse<List<MatchSentRequestResponseDTO>>();
            try
            {
                var data = await _matchSentRequestRepository.GetByRequestId(UserSendRequestId);
                var mapper = _mapper.Map<List<MatchSentRequestResponseDTO>>(data);
                response.Data = mapper;
                response.statusCode = HttpStatusCode.OK;
                response.Message = "Get all request by user send request id successfully!";
            }
            catch (Exception ex)
            {
                response.Message = ex.Message;
                response.statusCode = HttpStatusCode.InternalServerError;
            }
            return response;
        }

        public async Task<StatusResponse<MatchSentRequestResponseDTO>> getById(int Id)
        {
            var response = new StatusResponse<MatchSentRequestResponseDTO>();
            try
            {
                var data = await _matchSentRequestRepository.GetById(Id);
                if (data == null)
                {
                    response.Message = "Request not found!";
                    response.statusCode = HttpStatusCode.NotFound;
                    return response;
                }
                var mapper = _mapper.Map<MatchSentRequestResponseDTO>(data);
                response.Data = mapper;
                response.statusCode = HttpStatusCode.OK;
                response.Message = "Get request by id successfully!";
            }
            catch (Exception ex)
            {
                response.Message = ex.Message;
                response.statusCode = HttpStatusCode.InternalServerError;
            }
            return response;
        }

        public async Task<StatusResponse<List<MatchSentRequestResponseDTO>>> GetResponseByUserAcceptId(int UserAcceptId)
        {
            var response = new StatusResponse<List<MatchSentRequestResponseDTO>>();
            try
            {
                var data = await _matchSentRequestRepository.GetByReceviedId(UserAcceptId);
                var filteredData = data.Where(r => r.status == SendRequestStatus.Pending).ToList();
                var mapper = _mapper.Map<List<MatchSentRequestResponseDTO>>(filteredData);
                response.Data = mapper;
                response.statusCode = HttpStatusCode.OK;
                response.Message = "Get all request by user accept id successfully!";
            }
            catch (Exception ex)
            {
                response.Message = ex.Message;
                response.statusCode = HttpStatusCode.InternalServerError;
            }
            return response;
        }

        public async Task<StatusResponse<MatchSentRequestResponseDTO>> SentRequest(MatchSentRequestRequestDTO dto)
        {
            var response = new StatusResponse<MatchSentRequestResponseDTO>();
            using (var transaction = new TransactionScope(TransactionScopeAsyncFlowOption.Enabled))
                try
                {
                    var data = new MatchesSendRequest()
                    {
                        MatchingId = dto.MatchingId,
                        PlayerRequestId = dto.PlayerRequestId,
                        PlayerRecieveId = dto.PlayerRecieveId,
                        status = SendRequestStatus.Pending,
                        CreateAt = DateTime.UtcNow,
                        LastUpdatedAt = DateTime.UtcNow
                    };
                    var flag = await _matchSentRequestRepository.Get().Where(x => x.MatchingId == dto.MatchingId && dto.PlayerRequestId == x.PlayerRequestId && x.PlayerRecieveId == dto.PlayerRecieveId && x.status != SendRequestStatus.Reject).ToListAsync();
                    if(flag != null)
                    {
                        response.Message = "Sent";
                        response.statusCode = HttpStatusCode.OK;
                        return response;
                    }
                    await _matchSentRequestRepository.AddAsync(data);
                    await _matchSentRequestRepository.SaveChangesAsync();
                    var dataUser = await _userRepository.GetById(dto.PlayerRequestId);
                    if (dataUser == null)
                    {
                        response.Message = "User not found!";
                        response.statusCode = HttpStatusCode.NotFound;
                        return response;
                    }
                    var notification = new Notification()
                    {
                        UserId = dto.PlayerRecieveId,
                        Message = $"{dataUser.LastName} sent you a match request",
                        CreatedAt = DateTime.UtcNow,
                        IsRead = false,
                        Type = NotificationType.MatchRequest,
                        ReferenceId = data.Id
                    };
                    await _notificationRepository.AddAsync(notification);

                    await _notificationRepository.SaveChangesAsync();
                    var responseData = _mapper.Map<MatchSentRequestResponseDTO>(data);
                    response.Data = responseData;
                    response.statusCode = HttpStatusCode.OK;
                    response.Message = "Sent request successfully!";
                    transaction.Complete();
                }
                catch (Exception ex)
                {
                    response.Message = ex.Message;
                    response.statusCode = System.Net.HttpStatusCode.InternalServerError;
                }
            return response;
        }
    }
}
