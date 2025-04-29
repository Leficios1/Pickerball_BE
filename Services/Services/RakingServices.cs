using AutoMapper;
using Database.DTO.Request;
using Database.DTO.Response;
using Database.Model;
using Microsoft.EntityFrameworkCore;
using Repository.Repository.Interfeace;
using Services.Services.Interface;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Transactions;

namespace Services.Services
{
    public class RakingServices : IRankingServices
    {
        private readonly IUserRepository _userRepository;
        private readonly IPlayerRepository _playerRepository;
        private readonly IRankingRepository _rankingRepository;
        private readonly ITouramentRepository _touramentRepository;
        private readonly IMapper _mapper;
        private readonly IRuleOfAwardRepository _ruleOfAwardRepository;
        private readonly IPaymentRepository _paymentRepository;

        public RakingServices(IUserRepository userRepository, IPlayerRepository playerRepository, IMapper mapper,
            IRankingRepository rankingRepository, ITouramentRepository touramentRepository, IRuleOfAwardRepository ruleOfAwardRepository,
            IPaymentRepository paymentRepository)
        {
            _userRepository = userRepository;
            _playerRepository = playerRepository;
            _mapper = mapper;
            _rankingRepository = rankingRepository;
            _touramentRepository = touramentRepository;
            _ruleOfAwardRepository = ruleOfAwardRepository;
            _paymentRepository = paymentRepository;
        }

        public async Task<StatusResponse<bool>> AwardForPlayer(List<RankingRequestDTO> dto)
        {
            var response = new StatusResponse<bool>();
            try
            {
                foreach (var dataInfo in dto)
                {
                    var data = await _rankingRepository.Get().Where(x => x.PlayerId == dataInfo.UserId && x.TournamentId == dataInfo.TouramentId).SingleOrDefaultAsync();
                    if (data == null)
                    {
                        response.statusCode = System.Net.HttpStatusCode.NotFound;
                        response.Message = $"Not found user: " + dataInfo.UserId + "or tourament: " + dataInfo.TouramentId;
                        return response;
                    }
                    data.PercentOfPrize = dataInfo.PercentOfPrize;
                    data.Prize = dataInfo.Award;
                }
            }
            catch (Exception ex)
            {
                response.statusCode = System.Net.HttpStatusCode.InternalServerError;
                response.Message = ex.Message;
            }
            return response;
        }

        public async Task<StatusResponse<bool>> AwardForPlayer(int tourId)
        {
            var response = new StatusResponse<bool>();
            using (var transaction = new TransactionScope(TransactionScopeAsyncFlowOption.Enabled))
            {
                try
                {
                    var touramentData = await _touramentRepository.GetById(tourId);
                    if (touramentData == null || touramentData.Status != "Completed")
                    {
                        response.statusCode = System.Net.HttpStatusCode.BadRequest;
                        response.Message = "Not Found this tournament or this tournament has not ended";
                        return response;
                    }
                    var userData = await _rankingRepository.Get().Where(x => x.TournamentId == tourId).OrderByDescending(x => x.Position).Take(4)
                        .ToListAsync();
                    if (userData == null || userData.Count() < 4)
                    {
                        response.statusCode = System.Net.HttpStatusCode.BadRequest;
                        response.Message = "This tournament didn't have ranking";
                        return response;
                    }
                    var index = 1;
                    foreach (var playerInfo in userData)
                    {
                        var ruleOfAward = await _ruleOfAwardRepository.Get().Where(x => x.Position == index).SingleOrDefaultAsync();
                        if (ruleOfAward == null)
                        {
                            response.statusCode = System.Net.HttpStatusCode.InternalServerError;
                            response.Message = "Doesn't have rule Of Award";
                            return response;
                        }
                        playerInfo.PercentOfPrize = ruleOfAward.PercentOfPrize;
                        var award = (touramentData.TotalPrize * ruleOfAward.PercentOfPrize) / 100;
                        playerInfo.Prize = award;
                        var paymentInfo = new Payments
                        {
                            UserId = playerInfo.PlayerId,
                            TournamentId = playerInfo.TournamentId,
                            Amount = award,
                            Note = $"Reward for top " + index + "in:" + touramentData.Name,
                            PaymentMethod = "Banking",
                            Status = PaymentStatus.Completed,
                            Type = TypePayment.Award,
                            PaymentDate = DateTime.Now,
                        };
                        await _paymentRepository.AddAsync(paymentInfo);
                        _rankingRepository.Update(playerInfo);
                    }
                    touramentData.isAward = true;
                    _touramentRepository.Update(touramentData);
                    await _touramentRepository.SaveChangesAsync();
                    await _rankingRepository.SaveChangesAsync();
                    await _paymentRepository.SaveChangesAsync();
                    transaction.Complete();
                }
                catch (Exception ex)
                {
                    response.statusCode = System.Net.HttpStatusCode.InternalServerError;
                    response.Message = ex.Message;
                }
                return response;
            }
        }

        public async Task<StatusResponse<List<RuleOfAwardResponseDTO>>> GetRuleOfAwardForPlayer()
        {
            var response = new StatusResponse<List<RuleOfAwardResponseDTO>>();
            try
            {
                var data = await _ruleOfAwardRepository.GetAll();
                var mapper = _mapper.Map<List<RuleOfAwardResponseDTO>>(data);
                response.Data = mapper;
                response.statusCode = System.Net.HttpStatusCode.OK;
                response.Message = "Successful";
            }catch(Exception ex)
            {
                response.statusCode = System.Net.HttpStatusCode.InternalServerError;
                response.Message = ex.Message;
            }
            return response;    
        }

        public async Task<StatusResponse<List<RankingResponseDTO>>> LeaderBoard()
        {
            var response = new StatusResponse<List<RankingResponseDTO>>();
            try
            {
                var data = await _userRepository.Get().Include(x => x.Player).OrderByDescending(x => x.Player.RankingPoint).Take(50).ToListAsync();
                response.Data = _mapper.Map<List<RankingResponseDTO>>(data);
                response.Message = "Get LeaderBoard Success";
                response.statusCode = System.Net.HttpStatusCode.OK;
            }
            catch (Exception ex)
            {
                response.Message = ex.Message;
                response.statusCode = System.Net.HttpStatusCode.InternalServerError;
            }
            return response;
        }

        public async Task<StatusResponse<List<RankingResponseDTO>>> LeaderBoardTourament(int tourId)
        {
            var response = new StatusResponse<List<RankingResponseDTO>>();
            try
            {
                var data = await _rankingRepository.Get().Where(x => x.TournamentId == tourId).Include(x => x.Player)
                                .ThenInclude(y => y.User).OrderByDescending(o => o.Points).ToListAsync();
                if (data == null)
                {
                    response.Data = null;
                    response.statusCode = System.Net.HttpStatusCode.OK;
                    response.Message = "This tourament doen's had eliminated!";
                    return response;
                }
                var mapper = _mapper.Map<List<RankingResponseDTO>>(data);
                response.Data = mapper;
                response.statusCode = System.Net.HttpStatusCode.OK;
                response.Message = "Successfull";
            }
            catch (Exception ex)
            {
                response.Message = ex.Message;
                response.statusCode = System.Net.HttpStatusCode.InternalServerError;
            }
            return response;
        }

        public Task<StatusResponse<RuleOfAwardResponseDTO>> UpdateRuleOfAwardForPlayer(RuleOfAwardRequestDTO dto)
        {
            throw new NotImplementedException();
        }
    }
}
