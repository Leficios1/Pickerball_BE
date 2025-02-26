
using AutoMapper;
using Database.DTO.Request;
using Database.DTO.Response;
using Database.Model;
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

        public MatchSentRequestServices(IMatchSentRequestRepository matchSentRequestRepository, IPlayerRepository playerRepository, IMatchesRepository matchRepository,
            IMapper mapper, ITeamMembersRepository membersRepository, ITeamRepository teamRepository)
        {
            _matchSentRequestRepository = matchSentRequestRepository;
            _playerRepository = playerRepository;
            _matchRepository = matchRepository;
            _mapper = mapper;
            _membersRepository = membersRepository;
            _teamRepository = teamRepository;
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
                    var getAllRequestByResponseId = await _matchSentRequestRepository.GetByReceviedId(UserAcceptId);
                    if (Accpet == SendRequestStatus.Accept)
                    {
                        data.status = Accpet;
                        data.LastUpdatedAt = DateTime.UtcNow;
                        foreach (var r in getAllRequestByResponseId)
                        {
                            if (r.Id != RequestId) // Không cập nhật chính request đã accept
                            {
                                r.status = SendRequestStatus.Reject;
                                _matchSentRequestRepository.Update(r);
                            }
                        }
                        _matchSentRequestRepository.Update(data);
                        await _matchSentRequestRepository.SaveChangesAsync();
                    }
                    var creatTeam = new Team()
                    {
                        Name = "Team Room: " + Guid.NewGuid().ToString().Substring(0, 6), // 🔥 Sử dụng GUID tránh lỗi ID null
                        CaptainId = data.PlayerRequestId,
                        Members = new List<TeamMembers>() // 🔥 Phải là danh sách
                    {
                        new TeamMembers
                        {
                            PlayerId = data.PlayerRequestId,
                            JoinedAt = DateTime.UtcNow
                        }
                    }
                    };

                    await _teamRepository.AddAsync(creatTeam);
                    await _teamRepository.SaveChangesAsync(); // 🔥 Lưu vào DB để có ID

                    // 🔥 Cập nhật TeamMembers sau khi Team đã có ID
                    creatTeam.Members.First().TeamId = creatTeam.Id;
                    _teamRepository.Update(creatTeam);
                    await _teamRepository.SaveChangesAsync();

                    response.Data = new MatchSentRequestResponseDTO
                    {
                        Id = data.Id,
                        PlayerRequestId = data.PlayerRequestId,
                        PlayerRecieveId = data.PlayerRecieveId,
                        status = data.status,
                        LastUpdatedAt = data.LastUpdatedAt
                    };

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
                var mapper = _mapper.Map<List<MatchSentRequestResponseDTO>>(data);
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
                await _matchSentRequestRepository.AddAsync(data);
                await _matchSentRequestRepository.SaveChangesAsync();
                var responseData = _mapper.Map<MatchSentRequestResponseDTO>(data);
                response.Data = responseData;
                response.statusCode = HttpStatusCode.OK;
                response.Message = "Sent request successfully!";
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
