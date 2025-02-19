using AutoMapper;
using Database.DTO.Request;
using Database.DTO.Response;
using Database.Model;
using Repository.Repository.Interface;
using Repository.Repository.Interfeace;
using Services.Services.Interface;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Threading.Tasks;
using System.Transactions;

namespace Services.Services
{
    public class MatchService : IMatchService
    {
        private readonly IMatchesRepository _matchesRepo;
        private readonly ITouramentMatchesRepository _touramentMatchesRepository;
        private readonly IMapper _mapper;

        public MatchService(IMatchesRepository matchesRepo, ITouramentMatchesRepository touramentMatchesRepository, IMapper mapper)
        {
            _matchesRepo = matchesRepo;
            _touramentMatchesRepository = touramentMatchesRepository;
            _mapper = mapper;
        }

        public async Task<StatusResponse<MatchResponseDTO>> CreateRoomAsync(MatchRequestDTO dto)
        {
            var response = new StatusResponse<MatchResponseDTO>();
            using (var transaction = new TransactionScope(TransactionScopeAsyncFlowOption.Enabled))
                try
                {
                    var match = new Matches
                    {
                        Title = dto.Title,
                        Description = dto.Description,
                        MatchDate = dto.MatchDate,
                        VenueId = dto.VenueId,
                        Status = dto.Status,
                        MatchCategory = dto.MatchCategory,
                        MatchFormat = dto.MatchFormat,
                        WinScore = dto.WinScore,
                        IsPublic = dto.IsPublic,
                    };
                    if (dto.RefereeId != null)
                    {
                        match.RefereeId = dto.RefereeId;
                    }
                    await _matchesRepo.AddAsync(match);
                    await _matchesRepo.SaveChangesAsync();

                    if (dto.TouramentId != null)
                    {
                        var touramentMatch = new TouramentMatches
                        {
                            MatchesId = match.Id,
                            TournamentId = dto.TouramentId.Value,
                            CreateAt = DateTime.UtcNow,
                        };
                        await _touramentMatchesRepository.AddAsync(touramentMatch);
                        await _touramentMatchesRepository.SaveChangesAsync();
                    }

                    var matchResponse = new MatchResponseDTO
                    {
                        Id = match.Id,
                        Title = match.Title,
                        Description = match.Description,
                        MatchDate = match.MatchDate,
                        VenueId = match.VenueId,
                        Status = match.Status,
                        MatchCategory = match.MatchCategory,
                        MatchFormat = match.MatchFormat,
                        WinScore = match.WinScore,
                        IsPublic = match.IsPublic,
                        RefereeId = match.RefereeId
                    };

                    response.Data = matchResponse;
                    response.statusCode = HttpStatusCode.OK;
                    response.Message = "Room created successfully!";
                    return response;
                }
                catch (Exception ex)
                {
                    response.statusCode = HttpStatusCode.InternalServerError;
                    response.Message = ex.Message;
                    return response;
                }
        }

        public async Task<StatusResponse<MatchResponseDTO>> GetRoomByIdAsync(int id)
        {
            var response = new StatusResponse<MatchResponseDTO>();
            try
            {
                var match = await _matchesRepo.GetByIdAsync(id);
                if (match == null)
                {
                    response.statusCode = HttpStatusCode.NotFound;
                    response.Message = "Room not found!";
                    return response;
                }

                var matchResponse = new MatchResponseDTO
                {
                    Id = match.Id,
                    Title = match.Title,
                    Description = match.Description,
                    MatchDate = match.MatchDate,
                    VenueId = match.VenueId,
                    Status = match.Status,
                    MatchCategory = match.MatchCategory,
                    MatchFormat = match.MatchFormat,
                    IsPublic = match.IsPublic,
                    RefereeId = match.RefereeId,
                    Team1Score = match.Team1Score,
                    Team2Score = match.Team2Score,
                    WinScore = match.WinScore
                };

                response.Data = matchResponse;
                response.statusCode = HttpStatusCode.OK;
                response.Message = "Room retrieved successfully!";
                return response;
            }
            catch (Exception ex)
            {
                response.statusCode = HttpStatusCode.InternalServerError;
                response.Message = ex.Message;
                return response;
            }
        }

        public async Task<StatusResponse<IEnumerable<MatchResponseDTO>>> GetPublicRoomsAsync()
        {
            var response = new StatusResponse<IEnumerable<MatchResponseDTO>>();
            try
            {
                var matches = await _matchesRepo.GetAllAsync();
                var matchResponses = matches.Select(match => new MatchResponseDTO
                {
                    Id = match.Id,
                    Title = match.Title,
                    Description = match.Description,
                    MatchDate = match.MatchDate,
                    VenueId = match.VenueId,
                    Status = match.Status,
                    MatchCategory = match.MatchCategory,
                    MatchFormat = match.MatchFormat,
                    IsPublic = match.IsPublic,
                    RefereeId = match.RefereeId,
                    Team1Score = match.Team1Score,
                    Team2Score = match.Team2Score,
                    WinScore = match.WinScore
                }).ToList();

                response.Data = matchResponses;
                response.statusCode = HttpStatusCode.OK;
                response.Message = "Public rooms retrieved successfully!";
                return response;
            }
            catch (Exception ex)
            {
                response.statusCode = HttpStatusCode.InternalServerError;
                response.Message = ex.Message;
                return response;
            }
        }

        public async Task<StatusResponse<bool>> DeleteRoomAsync(int id)
        {
            var response = new StatusResponse<bool>();
            try
            {
                var match = await _matchesRepo.GetByIdAsync(id);
                if (match == null)
                {
                    response.statusCode = HttpStatusCode.NotFound;
                    response.Message = "Room not found!";
                    return response;
                }

                _matchesRepo.Delete(match);
                await _matchesRepo.SaveChangesAsync();

                response.Data = true;
                response.statusCode = HttpStatusCode.OK;
                response.Message = "Room deleted successfully!";
                return response;
            }
            catch (Exception ex)
            {
                response.statusCode = HttpStatusCode.InternalServerError;
                response.Message = ex.Message;
                return response;
            }
        }

        public async Task<StatusResponse<MatchResponseDTO>> UpdateRoomAsync(int id, MatchRequestDTO dto)
        {
            var response = new StatusResponse<MatchResponseDTO>();
            try
            {
                var match = await _matchesRepo.GetByIdAsync(id);
                if (match == null)
                {
                    response.statusCode = HttpStatusCode.NotFound;
                    response.Message = "Room not found!";
                    return response;
                }

                match.Title = dto.Title;
                match.Description = dto.Description;
                match.MatchDate = dto.MatchDate;
                match.VenueId = dto.VenueId;
                match.Status = dto.Status;
                match.MatchCategory = dto.MatchCategory;
                match.MatchFormat = dto.MatchFormat;
                match.IsPublic = dto.IsPublic;
                match.RefereeId = dto.RefereeId;

                _matchesRepo.Update(match);
                await _matchesRepo.SaveChangesAsync();

                var matchResponse = new MatchResponseDTO
                {
                    Id = match.Id,
                    Title = match.Title,
                    Description = match.Description,
                    MatchDate = match.MatchDate,
                    VenueId = match.VenueId,
                    Status = match.Status,
                    MatchCategory = match.MatchCategory,
                    MatchFormat = match.MatchFormat,
                    IsPublic = match.IsPublic,
                    RefereeId = match.RefereeId,
                    Team1Score = match.Team1Score,
                    Team2Score = match.Team2Score,
                    WinScore = match.WinScore
                };

                response.Data = matchResponse;
                response.statusCode = HttpStatusCode.OK;
                response.Message = "Room updated successfully!";
                return response;
            }
            catch (Exception ex)
            {
                response.statusCode = HttpStatusCode.InternalServerError;
                response.Message = ex.Message;
                return response;
            }
        }

        public async Task<StatusResponse<List<MatchResponseDTO>>> GetMatchesByTouramentId(int TouramentId)
        {
            var response = new StatusResponse<List<MatchResponseDTO>>();
            try
            {
                var matches = await _touramentMatchesRepository.getByTouramentId(TouramentId);
                var mapper = _mapper.Map<List<MatchResponseDTO>>(matches);
                response.Data = mapper;
                response.statusCode = HttpStatusCode.OK;
                response.Message = "Get matches by tourament id successfully!";
            }
            catch (Exception ex)
            {
                response.statusCode = HttpStatusCode.InternalServerError;
                response.Message = ex.Message;
            }
            return response;
        }
    }
}
