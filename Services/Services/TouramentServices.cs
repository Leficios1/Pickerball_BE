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
using Microsoft.EntityFrameworkCore;

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
        private readonly ITournamentTeamRequestRepository _tournamentTeamRequestRepository;

        public TouramentServices(ITouramentRepository touramentRepository, IMapper mapper, ISponsorRepository sponsorRepository, IPlayerRepository playerRepository,
            IMatchesRepository matchRepository, ITournamentRegistrationRepository tournamentRegistrationRepository, ITouramentMatchesRepository touramentMatchesRepository
            , ITeamRepository teamRepository, IUserRepository userRepository, IPaymentRepository paymentRepository, ISponserTouramentRepository sponserTouramentRepository,
            ITournamentTeamRequestRepository tournamentTeamRequestRepository)
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
            _tournamentTeamRequestRepository = tournamentTeamRequestRepository;
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
                data.Descreption = dto.Description;
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
                var sponnerList = data
                            .GroupBy(x => x.SponsorId)
                            .Select(group => new SponerDetails
                            {
                                Id = group.Key,
                                Name = group.First().Sponsor.CompanyName,
                                Logo = group.First().Sponsor.LogoUrl,
                                Website = group.First().Sponsor.UrlSocial,
                                Donate = group.Sum(x => x.SponsorAmount)
                            })
                            .ToList();
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
                int? TotalPage = null;

                if (PageNumber.HasValue || Pagesize.HasValue)
                {
                    Pagesize ??= 10;
                    PageNumber ??= 1;
                    data = data
                        .Skip((PageNumber.Value - 1) * Pagesize.Value)
                        .Take(Pagesize.Value)
                        .ToList();

                    TotalPage = (int)Math.Ceiling((double)TotalItem / Pagesize.Value);
                }
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
                                    ? await _playerRepository.GetById(playerRegistrationDetails.PartnerId.Value) : null;
                        if (playerData != null)
                        {
                            var userData = await _userRepository.GetById(playerData.PlayerId);
                            var paymentData = await _paymentRepository.Get().Where(x => x.UserId == playerData.PlayerId && x.TournamentId == id).SingleOrDefaultAsync();
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
                    response.statusCode = HttpStatusCode.OK;
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

        public async Task<StatusResponse<List<TournamentResponseDTO>>> GetAllTouramentBySponnerId(int sponnerId)
        {
            var response = new StatusResponse<List<TournamentResponseDTO>>();
            try
            {
                var organization = await _touramentRepository.Get().Where(x => x.OrganizerId == sponnerId).ToListAsync();
                var data = await _sponserTouramentRepository.Get().Where(x => x.SponsorId == sponnerId).Select(x => x.Tournament).ToListAsync();
                var combinedTournaments = organization.Concat(data).Distinct().ToList();
                if (combinedTournaments == null || !combinedTournaments.Any())
                {
                    response.Message = "This sponner doesn't has any tourament";
                    response.statusCode = HttpStatusCode.OK;
                    return response;
                }
                response.Data = _mapper.Map<List<TournamentResponseDTO>>(combinedTournaments);
                response.statusCode = HttpStatusCode.OK;
                response.Message = "Get All Tournament Successfully";

            }
            catch (Exception ex)
            {
                response.Message = ex.Message;
                response.statusCode = HttpStatusCode.InternalServerError;
            }
            return response;
        }

        public async Task<StatusResponse<List<AllTouramentResponseDTO>>> checkAllJoinTourament(int userId)
        {
            var response = new StatusResponse<List<AllTouramentResponseDTO>>();
            try
            {
                var data = await _touramentRepository.GetAll();
                var dataRegis = await _tournamentRegistrationRepository.Get().Where(x => x.PlayerId == userId || x.PartnerId == userId).ToListAsync();
                var regisStatus = dataRegis.ToDictionary(x => x.TournamentId, x => x.IsApproved);
                foreach (var check in data)
                {
                    int status;
                    if (regisStatus.TryGetValue(check.Id, out var regisStatus1))
                    {
                        switch (regisStatus1)
                        {
                            case TouramentregistrationStatus.Approved:
                                status = 1;
                                break;
                            case TouramentregistrationStatus.Pending:
                                status = 2;
                                break;
                            case TouramentregistrationStatus.Rejected:
                                status = 3;
                                break;
                            case TouramentregistrationStatus.Waiting:
                                status = 4;
                                break;
                            case TouramentregistrationStatus.Eliminated:
                                status = 5;
                                break;
                            default:
                                status = 7;
                                break;
                        }
                    }
                    else
                    {
                        status = 6;
                    }
                    var responseData = new AllTouramentResponseDTO
                    {
                        TouramentId = check.Id,
                        Status = status
                    };
                    if (response.Data == null)
                    {
                        response.Data = new List<AllTouramentResponseDTO>();
                    }
                    response.Data.Add(responseData);
                }
                response.statusCode = HttpStatusCode.OK;
                response.Message = "Get All Tournament Successfully";
            }
            catch (Exception ex)
            {
                response.Message = ex.Message;
                response.statusCode = HttpStatusCode.InternalServerError;
            }
            return response;
        }

        public async Task<StatusResponse<AllTouramentResponseDTO>> checkJoinTounramentorNot(int userId, int TournamentId)
        {
            var response = new StatusResponse<AllTouramentResponseDTO>();
            try
            {
                var regisData = await _tournamentRegistrationRepository.Get().Where(x => x.PlayerId == userId && x.TournamentId == TournamentId || x.PartnerId == userId && x.TournamentId == TournamentId).SingleOrDefaultAsync();
                if (regisData == null)
                {
                    response.Message = "Not Found";
                    response.statusCode = HttpStatusCode.NotFound;
                    return response;
                }
                response.Data = new AllTouramentResponseDTO
                {
                    TouramentId = TournamentId,
                    Status = (int)regisData.IsApproved
                };
                var flag = await _tournamentTeamRequestRepository.Get().Where(x => x.RegistrationId == regisData.Id && x.PartnerId == userId && x.Status == TournamentRequestStatus.Pending).SingleOrDefaultAsync();
                if (flag != null)
                {
                    response.Data.Status = 6;
                }
                response.statusCode=HttpStatusCode.OK;
                response.Message = "Check Join Tournament Successfully";
            }
            catch (Exception ex)
            {
                response.Message = ex.Message;
                response.statusCode = HttpStatusCode.InternalServerError;
            }
            return response;
        }
    }
}
