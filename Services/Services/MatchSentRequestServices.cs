
using AutoMapper;
using Database.DTO.Response;
using Database.Model;
using Repository.Repository.Interface;
using Repository.Repository.Interfeace;
using Services.Services.Interface;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Services.Services
{
    public class MatchSentRequestServices : IMatchSentRequestServices
    {
        private readonly IMatchSentRequestRepository _matchSentRequestRepository;
        private readonly IPlayerRepository _playerRepository;
        private readonly IMatchesRepository _matchRepository;
        private readonly IMapper _mapper;

        public MatchSentRequestServices(IMatchSentRequestRepository matchSentRequestRepository, IPlayerRepository playerRepository, IMatchesRepository matchRepository, IMapper mapper)
        {
            _matchSentRequestRepository = matchSentRequestRepository;
            _playerRepository = playerRepository;
            _matchRepository = matchRepository;
            _mapper = mapper;
        }

        public Task<StatusResponse<MatchSentRequestResponseDTO>> AcceptRequest(int SentRequestId, int PlayerAcceptId)
        {
            throw new NotImplementedException();
        }

        public Task<StatusResponse<MatchSentRequestResponseDTO>> GetRequestById(int id)
        {
            throw new NotImplementedException();
        }

        public async Task<StatusResponse<MatchSentRequestResponseDTO>> SentRequest(MatchSentRequestResponseDTO dto)
        {
            var response = new StatusResponse<MatchSentRequestResponseDTO>();
            try
            {
                var mapper = _mapper.Map<MatchesSendRequest>(dto);
                mapper.Id = dto.Id;

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
