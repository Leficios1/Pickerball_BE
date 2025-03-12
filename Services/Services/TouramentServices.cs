using AutoMapper;
using Database.DTO.Request;
using Database.DTO.Response;
using Database.Model;
using Repository.Repository.Interface;
using Repository.Repository.Interfeace;
using Services.Services.Interface;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;
using System.Transactions;
using Services.Partial;
using Repository.Repository;

namespace Services.Services
{
    public class TouramentServices : ITouramentServices
    {
        private readonly ITouramentRepository _touramentRepository;
        private readonly IMapper _mapper;
        private readonly ISponsorRepository _sponsorRepository;
        private readonly IPlayerRepository _playerRepository;
        private readonly IMatchesRepository _matchRepository;
        private readonly IUserRepository _userRepository;
        private readonly ITournamentRegistrationRepository _tournamentRegistrationRepository;
        private readonly ITouramentMatchesRepository _touramentMatchesRepository;
        private readonly ITeamRepository _teamRepository;
        private readonly IPaymentRepository _paymentRepository;
        private readonly ISponserTouramentRepository _sponserTouramentRepository;

        public TouramentServices(ITouramentRepository touramentRepository, IMapper mapper, ISponsorRepository sponsorRepository, IPlayerRepository playerRepository,
            IMatchesRepository matchRepository, ITournamentRegistrationRepository tournamentRegistrationRepository, ITouramentMatchesRepository touramentMatchesRepository
            , ITeamRepository teamRepository, IUserRepository userRepository, IPaymentRepository paymentRepository, ISponserTouramentRepository sponserTouramentRepository)
        {
            _touramentRepository = touramentRepository;
            _mapper = mapper;
            _sponsorRepository = sponsorRepository;
            _playerRepository = playerRepository;
            _matchRepository = matchRepository;
            _tournamentRegistrationRepository = tournamentRegistrationRepository;
            _touramentMatchesRepository = touramentMatchesRepository;
            _teamRepository = teamRepository;
            _userRepository = userRepository;
            _paymentRepository = paymentRepository;
            _sponserTouramentRepository = sponserTouramentRepository;
        }

        public async Task<StatusResponse<TournamentResponseDTO>> CreateTournament(TournamentRequestDTO dto)
        {
            var response = new StatusResponse<TournamentResponseDTO>();
            try
            {
                var sponnerData = await _sponsorRepository.GetById(dto.OrganizerId);
                if (sponnerData == null || sponnerData.isAccept == false)
                {
                    response.Message = "Sponner not found or not accept";
                    response.statusCode = HttpStatusCode.NotFound;
                    return response;
                }
                if (dto.IsFree == true)
                {
                    if (dto.EntryFee == null)
                    {
                        response.statusCode = HttpStatusCode.BadRequest;
                        response.Message = "Fee is required";
                        return response;
                    }
                    if (dto.EntryFee < 0)
                    {
                        response.statusCode = HttpStatusCode.BadRequest;
                        response.Message = "Fee must be greater than 0";
                        return response;
                    }
                }
                else
                {
                    dto.EntryFee = 0;
                }
                var data = _mapper.Map<Tournaments>(dto);
                data.Status = "Pending"; // Default status is "Pending"
                data.IsAccept = false; // Default is not accept
                await _touramentRepository.AddAsync(data);
                await _touramentRepository.SaveChangesAsync();
                response.Data = _mapper.Map<TournamentResponseDTO>(data);
                response.statusCode = HttpStatusCode.OK;
                response.Message = "Tournament Created Successfully";
            }
            catch (Exception ex)
            {
                response.Message = ex.Message;
                response.statusCode = HttpStatusCode.InternalServerError;
            }
            return response;
        }

        public Task<StatusResponse<TournamentResponseDTO>> DeleteTournament(int id)
        {
            throw new NotImplementedException();
        }

        public async Task<StatusResponse<bool>> DonateForTourament(SponnerTouramentRequestDTO dto)
        {
            var response = new StatusResponse<bool>();
            using (var transaction = new TransactionScope(TransactionScopeAsyncFlowOption.Enabled))
                try
                {
                    // Kiểm tra nhà tài trợ có tồn tại không?
                    var sponsor = await _sponsorRepository.GetById(dto.SponnerId);
                    if (sponsor == null || !sponsor.isAccept)
                    {
                        response.Message = "Sponsor not found or not approved!";
                        response.statusCode = HttpStatusCode.BadRequest;
                        return response;
                    }

                    // Kiểm tra Tournament có tồn tại không?
                    var tournament = await _touramentRepository.GetById(dto.TouramentId);
                    if (tournament == null)
                    {
                        response.Message = "Tournament not found!";
                        response.statusCode = HttpStatusCode.NotFound;
                        return response;
                    }

                    // Thêm khoản tài trợ vào bảng `TournamentSponsors`
                    var tournamentSponsor = new SponnerTourament
                    {
                        TournamentId = dto.TouramentId,
                        SponsorId = dto.SponnerId,
                        SponsorAmount = dto.Amount,
                        SponsorNote = dto.Note,
                        CreatedAt = DateTime.UtcNow
                    };

                    await _sponserTouramentRepository.AddAsync(tournamentSponsor);
                    await _sponserTouramentRepository.SaveChangesAsync();

                    // 4Cập nhật tổng số tiền tài trợ của Tournament
                    tournament.TotalPrize += dto.Amount;
                    _touramentRepository.Update(tournament);
                    await _touramentRepository.SaveChangesAsync();

                    // Trả về kết quả
                    response.Data = true;
                    response.Message = "Donate successful!";
                    response.statusCode = HttpStatusCode.OK;

                    //Hoàn thành Transaction
                    transaction.Complete();
                }
                catch (Exception ex)
                {
                    response.Message = ex.Message;
                    response.statusCode = HttpStatusCode.InternalServerError;
                }
            return response;
        }

        public async Task<StatusResponse<List<SponerDetails>>> GetAllSponnerByTouramentId(int TouramentId)
        {
            var response = new StatusResponse<List<SponerDetails>>();
            try
            {
                var data = await _sponserTouramentRepository.GetAllSponnerByTouramentId(TouramentId);
                if (data == null)
                {
                    response.Message = "Sponner not found";
                    response.statusCode = HttpStatusCode.NotFound;
                    return response;
                }
                var sponnerList = data.Select(dataItem => new SponerDetails
                {
                    Id = dataItem.Sponsor.SponsorId,
                    Name = dataItem.Sponsor.CompanyName,
                    Logo = dataItem.Sponsor.LogoUrl,
                    Website = dataItem.Sponsor.UrlSocial
                }).ToList();
                response.Data = sponnerList;
                response.statusCode = HttpStatusCode.OK;
                response.Message = "Get All Sponner Successfully";
            }
            catch (Exception ex)
            {
                response.Message = ex.Message;
                response.statusCode = HttpStatusCode.InternalServerError;
            }
            return response;
        }

        public async Task<StatusResponse<List<TournamentResponseDTO>>> GetAllTournament(int? PageNumber, int? Pagesize, bool isOrderbyCreateAt)
        {
            var response = new StatusResponse<List<TournamentResponseDTO>>();
            try
            {
                var data = await _touramentRepository.GetAllTournament();
                var TotalItem = data.Count();

                if (isOrderbyCreateAt == true)
                {
                    data = data.OrderByDescending(x => x.CreateAt).ToList();
                }
                if (PageNumber.HasValue && Pagesize.HasValue)
                {
                    data = data.Skip((PageNumber.Value - 1) * Pagesize.Value).Take(Pagesize.Value).ToList();
                }
                else
                {
                    Pagesize = 10;
                    PageNumber = 1;
                    data = data.Skip((PageNumber.Value - 1) * Pagesize.Value).Take(Pagesize.Value).ToList();
                }
                int TotalPage = (Pagesize.HasValue && Pagesize > 0) ? (int)Math.Ceiling(TotalItem / (double)Pagesize.Value) : 1;
                response.Data = _mapper.Map<List<TournamentResponseDTO>>(data);
                response.statusCode = HttpStatusCode.OK;
                response.Message = "Get All Tournament Successfully";
                response.TotalItems = TotalItem;
                response.TotalPages = TotalPage;
            }
            catch (Exception ex)
            {
                response.Message = ex.Message;
                response.statusCode = HttpStatusCode.InternalServerError;
            }
            return response;
        }

        public async Task<StatusResponse<TournamentResponseDTO>> getById(int id)
        {
            var response = new StatusResponse<TournamentResponseDTO>();
            try
            {
                var data = await _touramentRepository.GetById(id);
                if (data == null)
                {
                    response.Message = "Tournament not found";
                    response.statusCode = HttpStatusCode.NotFound;
                    return response;
                }
                var ListMatchByTourament = await _touramentMatchesRepository.getMatchByTouramentId(id);
                List<MatcheDetails>? matcheDetailsList = new List<MatcheDetails>();
                List<RegistrationDetails>? registrationDetails = new List<RegistrationDetails>();
                List<SponerDetails>? sponerDetails = new List<SponerDetails>();
                if (ListMatchByTourament != null)
                {
                    foreach (var matchDetails in ListMatchByTourament)
                    {
                        var playdeDetails = await _teamRepository.GetTeamsWithMatchingIdAsync(matchDetails.MatchesId);
                        foreach (var member in playdeDetails)
                        {
                            if (playdeDetails != null && member.Members.Any())
                            {
                                var playerIdInTeam = member.Members.Select(x => x.Playermember.PlayerId).ToList();
                                var matchData = await _matchRepository.GetById(matchDetails.MatchesId);
                                var matcheDetails = new MatcheDetails
                                {
                                    Id = matchDetails.Id,
                                    PlayerId1 = playerIdInTeam.ElementAtOrDefault(0),
                                    PlayerId2 = playerIdInTeam.ElementAtOrDefault(1),
                                    PlayerId3 = playerIdInTeam.ElementAtOrDefault(2),
                                    PlayerId4 = playerIdInTeam.ElementAtOrDefault(3),
                                    ScheduledTime = matchData.MatchDate,
                                    Score = $"{matchData.Team1Score} - {matchData.Team2Score}",
                                    Result = matchData.Status.ToString()
                                };
                                matcheDetailsList.Add(matcheDetails);
                            }
                        }
                    }
                }
                else
                {
                    matcheDetailsList = null;
                }

                var playerRegistrationData = await _tournamentRegistrationRepository.getByTournamentId(id);
                if (playerRegistrationData != null)
                {
                    foreach (var playerRegistrationDetails in playerRegistrationData)
                    {
                        var playerData = await _playerRepository.GetById(playerRegistrationDetails.PlayerId);
                        var partner = playerRegistrationDetails.PartnerId.HasValue
                                    ? await _playerRepository.GetById(playerRegistrationDetails.PartnerId.Value): null;
                        if (playerData != null)
                        {
                            var userData = await _userRepository.GetById(playerData.PlayerId);
                            var paymentData = await _paymentRepository.GetPaymentByUserId(playerData.PlayerId);
                            var playerRegistration = new PlayerRegistrationDetails
                            {
                                FirstName = userData.FirstName,
                                LastName = userData.LastName,
                                SecondName = userData.SecondName,
                                Email = userData.Email,
                                Ranking = playerData.RankingPoint,
                                AvatarUrl = userData.AvatarUrl
                            };
                            var partnerDetails = partner != null ? await GetPartnerDetails(partner) : null;

                            var regis = new RegistrationDetails
                            {
                                Id = playerRegistrationDetails.Id,
                                PlayerId = playerRegistrationDetails.PlayerId,
                                RegisteredAt = playerRegistrationDetails.RegisteredAt,
                                PartnerId = playerRegistrationDetails.PartnerId,
                                isApproved = playerRegistrationDetails.IsApproved,
                                PlayerDetails = playerRegistration,
                                PartnerDetails = partnerDetails
                            };
                            if (paymentData != null)
                            {
                                regis.PaymentId = paymentData.Id;
                            }
                            registrationDetails.Add(regis);
                        }
                    }
                }
                else
                {
                    registrationDetails = null;
                }
                var tournamentResponse = _mapper.Map<TournamentResponseDTO>(data);
                tournamentResponse.TouramentDetails = matcheDetailsList;
                tournamentResponse.RegistrationDetails = registrationDetails;
                response.Data = tournamentResponse;
                response.statusCode = HttpStatusCode.OK;
                response.Message = "Get Tournament Successfully";
            }
            catch (Exception ex)
            {
                response.Message = ex.Message;
                response.statusCode = HttpStatusCode.InternalServerError;
            }
            return response;
        }

        private async Task<PlayerRegistrationDetails> GetPartnerDetails(Player partner)
        {
            var partnerUser = await _userRepository.GetById(partner.PlayerId);
            return new PlayerRegistrationDetails
            {
                FirstName = partnerUser.FirstName,
                LastName = partnerUser.LastName,
                SecondName = partnerUser.SecondName,
                Email = partnerUser.Email,
                Ranking = partner.RankingPoint,
                AvatarUrl = partnerUser.AvatarUrl
            };
        }

        public async Task<StatusResponse<List<TournamentResponseDTO>>> getByPlayerId(int PlayerId)
        {
            var response = new StatusResponse<List<TournamentResponseDTO>>();
            try
            {
                var registrations = await _tournamentRegistrationRepository.getAllByPlayerId(PlayerId);
                if (registrations == null || !registrations.Any())
                {
                    response.Message = "This player hasn't joined any tournaments";
                    response.statusCode = HttpStatusCode.NotFound;
                    return response;
                }
                var tournamentIds = registrations.Select(r => r.TournamentId).Distinct().ToList();
                var data = new List<Tournaments>();
                foreach (var t in tournamentIds)
                {
                    var tourament = await _touramentRepository.GetById(t);
                    if (tourament != null)
                    {
                        data.Add(tourament);
                    }
                }

                // Map dữ liệu sang DTO
                var tournamentList = _mapper.Map<List<TournamentResponseDTO>>(data);
                response.Data = tournamentList;
                response.statusCode = HttpStatusCode.OK;
                response.Message = "Get Tournament Successfully";
            }
            catch (Exception ex)
            {
                response.Message = ex.Message;
                response.statusCode = HttpStatusCode.InternalServerError;
            }
            return response;
        }

        public async Task<StatusResponse<TournamentResponseDTO>> UpdateTournament(TournamenUpdatetRequestDTO dto, int id)
        {
            var response = new StatusResponse<TournamentResponseDTO>();

            using (var transaction = new TransactionScope(TransactionScopeAsyncFlowOption.Enabled))
            {
                try
                {
                    var existingTournament = await _touramentRepository.GetById(id);
                    if (existingTournament == null)
                    {
                        return new StatusResponse<TournamentResponseDTO>
                        {
                            Message = "Tournament not found",
                            statusCode = HttpStatusCode.NotFound
                        };
                    }

                    // Apply the values from TournamenUpdatetRequestDTO
                    foreach (var property in typeof(TournamenUpdatetRequestDTO).GetProperties())
                    {
                        var value = property.GetValue(dto);
                        if (value != null)
                        {
                            var existingProperty = typeof(Tournaments).GetProperty(property.Name);
                            if (existingProperty != null)
                            {
                                existingProperty.SetValue(existingTournament, value);
                            }
                        }
                    }

                    _touramentRepository.Update(existingTournament);
                    await _touramentRepository.SaveChangesAsync();

                    response.Data = _mapper.Map<TournamentResponseDTO>(existingTournament);
                    response.statusCode = HttpStatusCode.OK;
                    response.Message = "Tournament Updated Successfully";
                    transaction.Complete();
                }
                catch (Exception ex)
                {
                    response.Message = ex.Message;
                    response.statusCode = HttpStatusCode.InternalServerError;
                }
            }
            return response;
        }
    }
}
