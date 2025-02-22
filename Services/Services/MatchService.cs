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
        private readonly ITeamService _teamService;
        private readonly ITeamMembersService _teamMembersService;
        private readonly ITouramentRepository _touramentRepository;
        private readonly ITeamRepository _teamRepository;


        public MatchService(IMatchesRepository matchesRepo, IMapper mapper, ITeamService teamService,
            ITeamMembersService teamMembersService, ITouramentMatchesRepository touramentMatchesRepository, ITouramentRepository touramentRepository, ITeamRepository teamRepository)
        {
            _matchesRepo = matchesRepo;
            _touramentMatchesRepository = touramentMatchesRepository;
            _mapper = mapper;
            _teamService = teamService;
            _teamMembersService = teamMembersService;
            _touramentMatchesRepository = touramentMatchesRepository;
            _touramentRepository = touramentRepository;
            _teamRepository = teamRepository;
        }

        public async Task<StatusResponse<RoomResponseDTO>> CreateRoomWithTeamsAsync(CreateRoomDTO dto)
        {
            var room = new MatchRequestDTO
            {
                Title = dto.Title,
                Description = dto.Description,
                MatchDate = dto.MatchDate,
                VenueId = dto.VenueId ?? 0,
                Status = dto.Status,
                MatchCategory = dto.MatchCategory,
                MatchFormat = dto.MatchFormat,
                WinScore = dto.WinScore,
                IsPublic = dto.IsPublic,
                RefereeId = dto.RefereeId,
                TouramentId = dto.TournamentId,
                RoomOnwerId = dto.RoomOnwer
            };

            var response = await CreateRoomAsync(room);
            if (response.statusCode == HttpStatusCode.OK)
            {
                var createRoomResponse = _mapper.Map<RoomResponseDTO>(response.Data);
                createRoomResponse.Teams = new List<TeamResponseDTO>();

                var team1Response = await CreateTeamForRoom(response.Data.Id, "Team 1");
                var team2Response = await CreateTeamForRoom(response.Data.Id, "Team 2");

                if (team1Response.statusCode == HttpStatusCode.OK && team2Response.statusCode == HttpStatusCode.OK)
                {
                    var teamMembers = CreateTeamMembers(dto, team1Response.Data.Id, team2Response.Data.Id);
                    await AddTeamMembers(teamMembers);

                    createRoomResponse.Teams.Add(await CreateTeamResponse(team1Response.Data.Id, teamMembers));
                    createRoomResponse.Teams.Add(await CreateTeamResponse(team2Response.Data.Id, teamMembers));
                }

                return new StatusResponse<RoomResponseDTO>
                {
                    statusCode = HttpStatusCode.OK,
                    Data = createRoomResponse,
                    Message = "Room created successfully"
                };
            }

            return new StatusResponse<RoomResponseDTO>
            {
                statusCode = response.statusCode,
                Data = null,
                Message = response.Message
            };
        }

        private async Task<StatusResponse<TeamResponseDTO>> CreateTeamForRoom(int roomId, string teamName)
        {
            var teamRequest = new TeamRequestDTO { Name = teamName, MatchingId = roomId };
            return await _teamService.CreateTeamAsync(teamRequest);
        }

        private List<TeamMemberRequestDTO> CreateTeamMembers(CreateRoomDTO dto, int team1Id, int team2Id)
        {
            var teamMembers = new List<TeamMemberRequestDTO>();

            if (dto.MatchFormat == MatchFormat.Team)
            {
                if (dto.Player1Id.HasValue)
                    teamMembers.Add(new TeamMemberRequestDTO { TeamId = team1Id, PlayerId = dto.Player1Id.Value });
                if (dto.Player2Id.HasValue)
                    teamMembers.Add(new TeamMemberRequestDTO { TeamId = team1Id, PlayerId = dto.Player2Id.Value });
                if (dto.Player3Id.HasValue)
                    teamMembers.Add(new TeamMemberRequestDTO { TeamId = team2Id, PlayerId = dto.Player3Id.Value });
                if (dto.Player4Id.HasValue)
                    teamMembers.Add(new TeamMemberRequestDTO { TeamId = team2Id, PlayerId = dto.Player4Id.Value });
            }
            else
            {
                if (dto.Player1Id.HasValue)
                    teamMembers.Add(new TeamMemberRequestDTO { TeamId = team1Id, PlayerId = dto.Player1Id.Value });
                if (dto.Player2Id.HasValue)
                    teamMembers.Add(new TeamMemberRequestDTO { TeamId = team2Id, PlayerId = dto.Player2Id.Value });
            }

            return teamMembers;
        }

        private async Task AddTeamMembers(List<TeamMemberRequestDTO> teamMembers)
        {
            foreach (var member in teamMembers)
            {
                await _teamMembersService.CreateTeamMemberAsync(member);
            }
        }

        private async Task<TeamResponseDTO> CreateTeamResponse(int teamId, List<TeamMemberRequestDTO> teamMembers)
        {
            var teamResponse = await _teamRepository.GetById(teamId);
            var teamMembersResponse = await _teamMembersService.GetTeamMembersByTeamIdAsync(teamId);

            return new TeamResponseDTO
            {
                Id = teamResponse.Id,
                Name = teamResponse.Name,
                CaptainId = teamResponse.CaptainId,
                MatchingId = teamResponse.MatchingId,
                Members = _mapper.Map<List<TeamMemberDTO>>(teamMembersResponse.Data)
            };
        }

        public async Task<StatusResponse<MatchResponseDTO>> CreateRoomAsync(MatchRequestDTO dto)
        {
            var response = new StatusResponse<MatchResponseDTO>();

            using (var transaction = new TransactionScope(TransactionScopeAsyncFlowOption.Enabled))
            {
                try
                {
                    var match = new Matches
                    {
                        Title = dto.Title,
                        Description = dto.Description,
                        MatchDate = dto.MatchDate,
                        Status = dto.Status,
                        MatchCategory = dto.MatchCategory,
                        MatchFormat = dto.MatchFormat,
                        WinScore = dto.WinScore,
                        IsPublic = dto.IsPublic,
                        RoomOwnerId = dto.RoomOnwerId,
                        RefereeId = dto.RefereeId,
                        VenueId = dto.VenueId != 0 ? dto.VenueId : (int?)null 
                    };

                    await _matchesRepo.AddAsync(match);
                    await _matchesRepo.SaveChangesAsync();

                    if (dto.TouramentId.HasValue && dto.TouramentId.Value != 0)
                    {
                        var touramentData = await _touramentRepository.GetById(dto.TouramentId.Value);
                        if(touramentData == null || touramentData.IsAccept == false)
                        {
                            response.statusCode = HttpStatusCode.BadRequest;
                            response.Message = "Tournament not found or not accepted yet!";
                            return response;
                        }
                        var tournamentMatch = new TouramentMatches
                        {
                            MatchesId = match.Id,
                            TournamentId = dto.TouramentId.Value,
                            CreateAt = DateTime.UtcNow
                        };

                        await _touramentMatchesRepository.AddAsync(tournamentMatch);
                    }

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
                        WinScore = match.WinScore,
                        IsPublic = match.IsPublic,
                        RefereeId = match.RefereeId
                    };

                    response.Data = matchResponse;
                    response.statusCode = HttpStatusCode.OK;
                    response.Message = "Room created successfully!";
                    transaction.Complete();
                }
                catch (Exception ex)
                {
                    response.statusCode = HttpStatusCode.InternalServerError;
                    response.Message = ex.Message;
                }
            } 

            return response;
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
