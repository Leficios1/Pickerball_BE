
using System.Net;
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
using Repository.Repository;
using static Microsoft.EntityFrameworkCore.DbLoggerCategory.Database;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Caching.Memory;

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
        private readonly ITeamMembersRepository _teamMembersRepository;
        private readonly IMatchScoreRepository _matchScoreRepository;
        private readonly ITournamentRegistrationRepository _touramentRegistrationRepository;
        private readonly IRankingRepository _rankingRepository;
        private readonly IPlayerRepository _playerRepository;
        private readonly IAchivementRepository _achivementRepository;
        private readonly IRuleOfAwardRepository _ruleOfAwardRepository;
        private readonly IMemoryCache _memoryCache;
        public MatchService(IMatchesRepository matchesRepo, IMapper mapper, ITeamService teamService,
            ITeamMembersService teamMembersService, ITouramentMatchesRepository touramentMatchesRepository,
            ITouramentRepository touramentRepository, ITeamRepository teamRepository, ITeamMembersRepository teamMembersRepository, IMatchScoreRepository matchScoreRepository,
            ITournamentRegistrationRepository tournamentRegistrationRepository, IRankingRepository rankingRepository, IPlayerRepository playerRepository, IAchivementRepository achivementRepository,
            IRuleOfAwardRepository ruleOfAwardRepository, IMemoryCache memoryCache)
        {
            _matchesRepo = matchesRepo;
            _mapper = mapper;
            _teamService = teamService;
            _teamMembersService = teamMembersService;
            _touramentMatchesRepository = touramentMatchesRepository;
            _touramentRepository = touramentRepository;
            _teamRepository = teamRepository;
            _teamMembersRepository = teamMembersRepository;
            _matchScoreRepository = matchScoreRepository;
            _touramentRegistrationRepository = tournamentRegistrationRepository;
            _rankingRepository = rankingRepository;
            _playerRepository = playerRepository;
            _achivementRepository = achivementRepository;
            _ruleOfAwardRepository = ruleOfAwardRepository;
            _memoryCache = memoryCache;
        }

        public async Task<StatusResponse<RoomResponseDTO>> CreateRoomWithTeamsAsync(CreateRoomDTO dto)
        {
            using (var transaction = new TransactionScope(TransactionScopeAsyncFlowOption.Enabled))
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

                    var team1Response = await CreateTeamForRoom(response.Data.Id, "Team 1", dto.Player1Id);
                    var team2Response = await CreateTeamForRoom(response.Data.Id, "Team 2", dto.Player2Id);

                    if (team1Response.statusCode == HttpStatusCode.OK && team2Response.statusCode == HttpStatusCode.OK)
                    {
                        var teamMembers = CreateTeamMembers(dto, team1Response.Data.Id, team2Response.Data.Id);
                        await AddTeamMembers(teamMembers);

                        createRoomResponse.Teams.Add(await CreateTeamResponse(team1Response.Data.Id, teamMembers));
                        createRoomResponse.Teams.Add(await CreateTeamResponse(team2Response.Data.Id, teamMembers));
                    }
                    transaction.Complete();
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
        }

        private async Task<StatusResponse<TeamResponseDTO>> CreateTeamForRoom(int roomId, string teamName, int? CaptainId)
        {
            var teamRequest = new TeamRequestDTO { Name = teamName, MatchingId = roomId, CaptainId = CaptainId };
            return await _teamService.CreateTeamAsync(teamRequest);
        }

        private List<TeamMemberRequestDTO> CreateTeamMembers(CreateRoomDTO dto, int team1Id, int team2Id)
        {
            var teamMembers = new List<TeamMemberRequestDTO>();
            //Sửa lại
            if (dto.MatchFormat == MatchFormat.DoubleMix || dto.MatchFormat == MatchFormat.DoubleMale || dto.MatchFormat == MatchFormat.DoubleFemale)
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
                MatchingId = (int)teamResponse.MatchingId,
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
                        RoomOwner = dto.RoomOnwerId,
                        RefereeId = dto.RefereeId,
                        VenueId = dto.VenueId != 0 ? dto.VenueId : (int?)null
                    };

                    await _matchesRepo.AddAsync(match);
                    await _matchesRepo.SaveChangesAsync();

                    if (dto.TouramentId.HasValue && dto.TouramentId.Value != 0)
                    {
                        var touramentData = await _touramentRepository.GetById(dto.TouramentId.Value);
                        if (touramentData == null || touramentData.IsAccept == false)
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
                        RefereeId = match.RefereeId,
                        RoomOwner = match.RoomOwner
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

        public async Task<StatusResponse<RoomResponseDTO>> GetRoomByIdAsync(int id)
        {
            var response = new StatusResponse<RoomResponseDTO>();
            try
            {
                var match = await _matchesRepo.GetById(id);
                if (match == null)
                {
                    response.statusCode = HttpStatusCode.NotFound;
                    response.Message = "Room not found!";
                    return response;
                }

                var matchResponse = _mapper.Map<RoomResponseDTO>(match);
                matchResponse.Team1Score = match.Team1Score;
                matchResponse.Team2Score = match.Team2Score;
                await PopulateTeamsForMatchResponse(matchResponse);

                response.Data = matchResponse;
                response.statusCode = HttpStatusCode.OK;
                response.Message = "Room retrieved successfully!";
            }
            catch (Exception ex)
            {
                response.statusCode = HttpStatusCode.InternalServerError;
                response.Message = ex.Message;
            }
            return response;
        }

        private async Task PopulateTeamsForMatchResponse(RoomResponseDTO matchResponse)
        {
            matchResponse.Teams = new List<TeamResponseDTO>();

            var teamsResponse = await _teamService.GetTeamsWithMatchingIdAsync(matchResponse.Id);
            if (teamsResponse.statusCode == HttpStatusCode.OK && teamsResponse.Data != null)
            {
                foreach (var team in teamsResponse.Data)
                {
                    var teamMembersResponse = await _teamMembersService.GetTeamMembersByTeamIdAsync(team.Id);
                    if (teamMembersResponse.statusCode == HttpStatusCode.OK && teamMembersResponse.Data != null)
                    {
                        var teamResponse = new TeamResponseDTO
                        {
                            Id = team.Id,
                            Name = team.Name,
                            CaptainId = team.CaptainId,
                            MatchingId = team.MatchingId,
                            Members = _mapper.Map<List<TeamMemberDTO>>(teamMembersResponse.Data)
                        };
                        matchResponse.Teams.Add(teamResponse);
                    }
                }
            }
        }

        public async Task<StatusResponse<IEnumerable<MatchResponseDTO>>> GetAllMatchingsAsync()
        {
            var response = new StatusResponse<IEnumerable<MatchResponseDTO>>();
            try
            {
                var matches = await _matchesRepo.GetAllAsync();
                var filterData = matches.OrderByDescending(x => x.CreateAt).ToList();
                var matchResponses = _mapper.Map<IEnumerable<MatchResponseDTO>>(filterData);

                response.Data = matchResponses;
                response.statusCode = HttpStatusCode.OK;
                response.Message = "Public rooms retrieved successfully!";
            }
            catch (Exception ex)
            {
                response.statusCode = HttpStatusCode.InternalServerError;
                response.Message = ex.Message;
            }
            return response;
        }
        public async Task<StatusResponse<IEnumerable<RoomResponseDTO>>> GetAllPublicRoomsAsync()
        {
            var response = new StatusResponse<IEnumerable<RoomResponseDTO>>();
            try
            {
                var matches = await _matchesRepo.GetRoomsByPublicStatusAsync(true);
                var filterData = matches.OrderByDescending(x => x.CreateAt).ToList();
                var matchResponses = _mapper.Map<IEnumerable<RoomResponseDTO>>(filterData);

                foreach (var matchResponse in matchResponses)
                {
                    await PopulateTeamsForMatchResponse(matchResponse);
                }

                response.Data = matchResponses;
                response.statusCode = HttpStatusCode.OK;
                response.Message = "Public rooms retrieved successfully!";
            }
            catch (Exception ex)
            {
                response.statusCode = HttpStatusCode.InternalServerError;
                response.Message = ex.Message;
            }
            return response;
        }
        public async Task<StatusResponse<List<RoomResponseDTO>>> GetRoomsByUserIdAsync(int userId)
        {
            var response = new StatusResponse<List<RoomResponseDTO>>();
            try
            {
                var teamMembersResponse = await _teamMembersService.GetTeamMembersByPlayerIdAsync(userId);
                if (teamMembersResponse == null || teamMembersResponse.Data == null || !teamMembersResponse.Data.Any())
                {
                    return CreateErrorResponse<List<RoomResponseDTO>>(HttpStatusCode.NotFound, "User not found or no teams found for user!");
                }

                var teamIds = teamMembersResponse.Data.Select(tm => tm.TeamId).Distinct();
                var rooms = new List<RoomResponseDTO>();

                foreach (var teamId in teamIds)
                {
                    if (teamId.HasValue)
                    {
                        var teamResponse = await _teamService.GetTeamByIdAsync(teamId.Value);
                        if (teamResponse != null && teamResponse.Data != null)
                        {
                            var matchResponse = await _matchesRepo.GetById(teamResponse.Data.MatchingId);
                            if (matchResponse != null)
                            {
                                var roomResponse = _mapper.Map<RoomResponseDTO>(matchResponse);
                                await PopulateTeamsForMatchResponse(roomResponse);
                                rooms.Add(roomResponse);
                            }
                        }
                    }
                }

                response.Data = rooms;
                response.statusCode = HttpStatusCode.OK;
                response.Message = "User's rooms retrieved successfully!";
                return response;
            }
            catch (Exception ex)
            {
                return CreateErrorResponse<List<RoomResponseDTO>>(HttpStatusCode.InternalServerError, ex.Message);
            }
        }
        public async Task<StatusResponse<TeamResponseDTO>> AddPlayerToTeamAsync(AddPlayerToTeamDTO dto)
        {
            var teamMember = new TeamMemberRequestDTO
            {
                TeamId = dto.TeamId,
                PlayerId = dto.PlayerId
            };

            var response = await _teamMembersService.CreateTeamMemberAsync(teamMember);
            if (response.statusCode == HttpStatusCode.OK)
            {
                return await GetTeamResponse(dto.TeamId);
            }

            return new StatusResponse<TeamResponseDTO>
            {
                statusCode = response.statusCode,
                Data = null,
                Message = response.Message
            };
        }

        private async Task<StatusResponse<TeamResponseDTO>> GetTeamResponse(int teamId)
        {
            var teamResponse = await _teamService.GetTeamByIdAsync(teamId);
            var teamMembersResponse = await _teamMembersService.GetTeamMembersByTeamIdAsync(teamId);

            var teamResponseDTO = new TeamResponseDTO
            {
                Id = teamResponse.Data.Id,
                Name = teamResponse.Data.Name,
                CaptainId = teamResponse.Data.CaptainId,
                MatchingId = teamResponse.Data.MatchingId,
                Members = _mapper.Map<List<TeamMemberDTO>>(teamMembersResponse.Data)
            };

            return new StatusResponse<TeamResponseDTO>
            {
                statusCode = HttpStatusCode.OK,
                Data = teamResponseDTO,
                Message = "Player added to team successfully"
            };
        }

        public async Task<StatusResponse<bool>> DeleteRoomAsync(int id)
        {
            var response = new StatusResponse<bool>();
            try
            {
                var match = await _matchesRepo.GetById(id);
                if (match == null)
                {
                    return CreateErrorResponse<bool>(HttpStatusCode.NotFound, "Room not found!");
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
                return CreateErrorResponse<bool>(HttpStatusCode.InternalServerError, ex.Message);
            }
        }

        public async Task<StatusResponse<MatchResponseDTO>> UpdateRoomAsync(int id, MatchUpdateRequestDTO dto)
        {
            var response = new StatusResponse<MatchResponseDTO>();
            try
            {
                var match = await _matchesRepo.GetById(id);
                if (match == null)
                {
                    return CreateErrorResponse<MatchResponseDTO>(HttpStatusCode.NotFound, "Room not found!");
                }
                if (match.Status == MatchStatus.Ongoing || match.Status == MatchStatus.Completed)
                {
                    return CreateErrorResponse<MatchResponseDTO>(HttpStatusCode.BadRequest, "Room is ongoing or completed, cannot update!");
                }
                // Apply the values from MatchUpdateRequestDTO
                foreach (var property in typeof(MatchUpdateRequestDTO).GetProperties())
                {
                    var value = property.GetValue(dto);
                    if (value != null)
                    {
                        var existingProperty = typeof(Matches).GetProperty(property.Name);
                        if (existingProperty != null)
                        {
                            existingProperty.SetValue(match, value);
                        }
                    }
                }

                _matchesRepo.Update(match);
                await _matchesRepo.SaveChangesAsync();

                response.Data = _mapper.Map<MatchResponseDTO>(match);
                response.statusCode = HttpStatusCode.OK;
                response.Message = "Room updated successfully!";
                return response;
            }
            catch (Exception ex)
            {
                return CreateErrorResponse<MatchResponseDTO>(HttpStatusCode.InternalServerError, ex.Message);
            }
        }

        public async Task<StatusResponse<List<MatchResponseDTO>>> GetMatchesByTouramentId(int TouramentId)
        {
            var response = new StatusResponse<List<MatchResponseDTO>>();
            try
            {
                var matches = await _touramentMatchesRepository.getMatchByTouramentId(TouramentId);
                if (matches == null || !matches.Any())
                {
                    response.statusCode = HttpStatusCode.OK;
                    response.Message = "No matches found for this tournament.";
                    return response;
                }
                var matchIds = matches.Select(tm => tm.MatchesId).ToList();

                var validMatches = new List<Matches>();
                foreach (var matchId in matchIds)
                {
                    var match = await _matchesRepo.GetById(matchId);
                    if (match != null) validMatches.Add(match);
                }

                // 🔥 Lấy danh sách Teams từng trận đấu (lặp tuần tự tránh lỗi)
                var teamsByMatch = new List<(int MatchId, List<Team> Teams)>();
                foreach (var match in validMatches)
                {
                    var teams = await _teamRepository.GetTeamsWithMatchingIdAsync(match.Id);
                    teamsByMatch.Add((match.Id, teams ?? new List<Team>()));
                }

                var matchResponseList = validMatches.Select(match =>
                {
                    var teams = teamsByMatch.FirstOrDefault(t => t.MatchId == match.Id).Teams;

                    return new MatchResponseDTO
                    {
                        Id = match.Id,
                        Title = match.Title,
                        Description = match.Description,
                        MatchDate = match.MatchDate,
                        CreateAt = match.CreateAt,
                        VenueId = match.VenueId,
                        Status = match.Status,
                        MatchCategory = match.MatchCategory,
                        MatchFormat = match.MatchFormat,
                        WinScore = match.WinScore,
                        RoomOwner = match.RoomOwner,
                        Team1Score = match.Team1Score,
                        Team2Score = match.Team2Score,
                        IsPublic = match.IsPublic,
                        RefereeId = match.RefereeId,

                        // 🔹 Thêm thông tin team
                        TeamResponse = teams?.Select(team => new TeamResponseDTO
                        {
                            Id = team.Id,
                            Name = team.Name,
                            CaptainId = team.CaptainId,
                            MatchingId = match.Id,

                            // 🔹 Thêm danh sách thành viên team
                            Members = team.Members?.Select(member => new TeamMemberDTO
                            {
                                Id = member.Id,
                                PlayerId = member.PlayerId,
                                TeamId = member.TeamId,
                                JoinedAt = member.JoinedAt
                            }).ToList() ?? new List<TeamMemberDTO>()
                        }).ToList() ?? new List<TeamResponseDTO>()
                    };
                }).ToList();
                response.Data = matchResponseList;
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
        private StatusResponse<T> CreateErrorResponse<T>(HttpStatusCode statusCode, string message)
        {
            return new StatusResponse<T>
            {
                statusCode = statusCode,
                Message = message
            };
        }

        public async Task<StatusResponse<bool>> joinMatch(JoinMatchRequestDTO dto)
        {
            var response = new StatusResponse<bool>();
            using (var transaction = new TransactionScope(TransactionScopeAsyncFlowOption.Enabled))
                try
                {
                    response.Data = false;
                    var match = await _matchesRepo.GetById(dto.MatchId);
                    if (match == null)
                    {
                        response.Message = "Match not found";
                        response.statusCode = HttpStatusCode.NotFound;
                        return response;
                    }
                    if (!match.IsPublic)
                    {
                        response.Message = "Match is not public";
                        response.statusCode = HttpStatusCode.BadRequest;
                    }
                    var teams = await _teamRepository.GetTeamsWithMatchingIdAsync(dto.MatchId);
                    if (teams == null || teams.Count < 2)
                    {
                        response.Message = "Teams not found";
                        response.statusCode = HttpStatusCode.NotFound;
                        return response;

                    }
                    int totalPlayers = teams.Sum(t => t.Members.Count);
                    //Sửa lại
                    int maxPlayers = match.MatchFormat == MatchFormat.DoubleMix || match.MatchFormat == MatchFormat.DoubleFemale ||
                        match.MatchFormat == MatchFormat.DoubleMale ? 4 : 2;
                    if (totalPlayers >= maxPlayers)
                    {
                        response.Message = "Match is full";
                        response.statusCode = HttpStatusCode.BadRequest;
                        return response;
                    }
                    bool isAlreadyInMatch = teams.Any(t => t.Members.Any(m => m.PlayerId == dto.UserJoinId));
                    if (isAlreadyInMatch)
                    {
                        response.Message = "Player already in match";
                        response.statusCode = HttpStatusCode.BadRequest;
                        return response;
                    }

                    string message = "";
                    //Sửa lại
                    if (match.MatchFormat == MatchFormat.DoubleMix || match.MatchFormat == MatchFormat.DoubleFemale || match.MatchFormat == MatchFormat.DoubleMale)
                    {
                        foreach (var team in teams)
                        {
                            if (team.CaptainId == null)
                            {
                                team.CaptainId = dto.UserJoinId;
                                _teamRepository.Update(team);
                                await _teamRepository.SaveChangesAsync();
                                message = "Player assigned as Captain!";
                                break;
                            }
                        }
                        foreach (var team in teams)
                        {
                            if (team.Members.Count < 2)
                            {
                                var teamMember = new TeamMembers
                                {
                                    TeamId = team.Id,
                                    PlayerId = dto.UserJoinId,
                                    JoinedAt = DateTime.UtcNow
                                };

                                await _teamMembersRepository.AddAsync(teamMember);
                                await _teamMembersRepository.SaveChangesAsync();
                                message = "Player added to team!";
                                break;
                            }
                        }
                    }
                    else
                    {
                        // If single Match, just add the player to the second team
                        foreach (var team in teams)
                        {
                            if (team.CaptainId == null)
                            {
                                team.CaptainId = dto.UserJoinId;
                                var teamMember = new TeamMembers
                                {
                                    TeamId = team.Id,
                                    PlayerId = dto.UserJoinId,
                                    JoinedAt = DateTime.UtcNow
                                };
                                _teamRepository.Update(team);
                                await _teamMembersRepository.AddAsync(teamMember);
                                await _teamMembersRepository.SaveChangesAsync();
                                await _teamRepository.SaveChangesAsync();
                                message = "Player assigned as Captain!";
                                break;
                            }
                        }
                    }
                    response.Data = true;
                    response.statusCode = HttpStatusCode.OK;
                    response.Message = message;
                    transaction.Complete();
                }
                catch (Exception ex)
                {
                    response.Message = ex.Message;
                    response.statusCode = HttpStatusCode.InternalServerError;
                }
            return response;
        }
        private StatusResponse<bool> SuccessResponse(string message)
        {
            return new StatusResponse<bool>
            {
                statusCode = HttpStatusCode.OK,
                Message = message,
                Data = true
            };
        }

        public async Task<StatusResponse<bool>> endMatchTourament(EndMatchTouramentRequestDTO dto)
        {
            var response = new StatusResponse<bool>();
            using (var transaction = new TransactionScope(TransactionScopeAsyncFlowOption.Enabled))
            {
                try
                {
                    var data = await _matchesRepo.GetById(dto.MatchId);
                    if (data == null)
                    {
                        response.Message = "Match not found";
                        response.statusCode = HttpStatusCode.NotFound;
                        return response;
                    }
                    if (data.Status != MatchStatus.Completed)
                    {
                        var matchDetails = new MatchScore
                        {
                            MatchId = dto.MatchId,
                            Round = dto.Round,
                            Note = dto.Note,
                            CurrentHaft = dto.CurrentHaft,
                            Team1Score = dto.Team1Score,
                            Team2Score = dto.Team2Score
                        };
                        if (dto.Log != null)
                        {
                            matchDetails.Log = dto.Log;
                        }
                        await _matchScoreRepository.AddAsync(matchDetails);

                        bool team1Win = false;
                        bool team2Win = false;

                        if (dto.Team1Score >= (int)data.WinScore && (dto.Team1Score - dto.Team2Score) >= 2)
                        {
                            data.Team1Score = (data.Team1Score ?? 0) + 1;
                            team1Win = true;
                        }
                        else if (dto.Team2Score >= (int)data.WinScore && (dto.Team2Score - dto.Team1Score) >= 2)
                        {
                            data.Team2Score = (data.Team2Score ?? 0) + 1;
                            team2Win = true;
                        }
                        if ((data.Team1Score ?? 0) == 2 || (data.Team2Score ?? 0) == 2)
                        {
                            data.Status = MatchStatus.Completed;
                        }
                        var teams = await _teamRepository.GetTeamsWithMatchingIdAsync(data.Id);
                        if (teams != null && teams.Count == 2)
                        {
                            var team1 = teams[0];
                            var team2 = teams[1];
                            Team loserTeam = null;

                            if ((data.Team1Score ?? 0) == 2)
                            {
                                loserTeam = team2;
                            }
                            else if ((data.Team2Score ?? 0) == 2)
                            {
                                loserTeam = team1;
                            }
                            var dataTourmanetMatche = await _touramentMatchesRepository.Get().Where(x => x.MatchesId == data.Id).SingleOrDefaultAsync();
                            if (dataTourmanetMatche == null)
                            {
                                response.statusCode = HttpStatusCode.BadRequest;
                                response.Message = "Tournament match not found";
                                return response;
                            }
                            if (loserTeam != null)
                            {
                                var loserPlayerIds = loserTeam.Members
                                    .Select(m => m.PlayerId)
                                    .ToList();
                                var existingRankings = await _rankingRepository.Get()
                                                .Where(r => r.TournamentId == dataTourmanetMatche.TournamentId)
                                                .OrderByDescending(r => r.Position)
                                                .ToListAsync();

                                int nextPosition = (existingRankings.FirstOrDefault()?.Position ?? 0) + 1;
                                int nextPoints = (existingRankings.FirstOrDefault()?.Points ?? 0) + 2;
                                foreach (var playerId in loserPlayerIds)
                                {
                                    var registration = await _touramentRegistrationRepository
                                        .Get()
                                        .Where(x => x.PlayerId == playerId && x.TournamentId == dataTourmanetMatche.TournamentId)
                                        .FirstOrDefaultAsync();

                                    if (registration != null)
                                    {
                                        registration.IsApproved = TouramentregistrationStatus.Eliminated;
                                        var rankingData = new Ranking
                                        {
                                            PlayerId = playerId,
                                            TournamentId = dataTourmanetMatche.TournamentId,
                                            Points = nextPoints,
                                            Position = nextPosition
                                        };
                                        await _rankingRepository.AddAsync(rankingData);
                                        await _rankingRepository.SaveChangesAsync();
                                        _touramentRegistrationRepository.Update(registration);
                                        await _touramentRegistrationRepository.SaveChangesAsync();
                                    }
                                }
                            }
                            var winner = await _touramentRegistrationRepository.Get().Where(x => x.TournamentId == dataTourmanetMatche.TournamentId &&
                            (x.IsApproved != TouramentregistrationStatus.Eliminated && x.IsApproved == TouramentregistrationStatus.Approved)).ToListAsync();
                            if (winner.Count() == 1)
                            {
                                var winnerId = winner.First();
                                winnerId.IsApproved = TouramentregistrationStatus.Winner;

                                var existingRankings = await _rankingRepository.Get()
                                    .Where(r => r.TournamentId == dataTourmanetMatche.TournamentId)
                                    .OrderByDescending(r => r.Position)
                                    .ToListAsync();
                                int nextPosition = (existingRankings.FirstOrDefault()?.Position ?? 0) + 1;
                                int nextPoints = (existingRankings.FirstOrDefault()?.Points ?? 0) + 2;
                                foreach (var winnerPlayer in winner)
                                {
                                    var touramentData = await _touramentRepository.GetById(winnerPlayer.TournamentId);
                                    var rankingData = new Ranking
                                    {
                                        PlayerId = winnerPlayer.PlayerId,
                                        TournamentId = dataTourmanetMatche.TournamentId,
                                        Points = nextPoints,
                                        Position = nextPosition
                                    };
                                    var Achivement = new Achievement
                                    {
                                        UserId = winnerPlayer.PlayerId,
                                        Title = "Winner of Tourament",
                                        Description = "Winner of Tourament in " + touramentData.Name,
                                        AwardedAt = DateTime.Now,
                                    };
                                    if (winnerPlayer.PartnerId != null)
                                    {
                                        var rankingDataPartner = new Ranking
                                        {
                                            PlayerId = (int)winnerPlayer.PartnerId,
                                            TournamentId = dataTourmanetMatche.TournamentId,
                                            Points = nextPoints,
                                            Position = nextPosition
                                        };
                                        var AchivementPartner = new Achievement
                                        {
                                            UserId = (int)winnerPlayer.PartnerId,
                                            Title = "Winner of Tourament",
                                            Description = "Winner of Tourament in " + touramentData.Name,
                                            AwardedAt = DateTime.Now,
                                        };
                                        await _rankingRepository.AddAsync(rankingDataPartner);
                                        await _achivementRepository.AddAsync(AchivementPartner);
                                    }
                                    await _achivementRepository.AddAsync(Achivement);
                                    await _rankingRepository.AddAsync(rankingData);
                                    await _rankingRepository.SaveChangesAsync();
                                    await _achivementRepository.SaveChangesAsync();
                                }
                            }
                            _matchesRepo.Update(data);
                            await _matchScoreRepository.SaveChangesAsync();
                            await _matchesRepo.SaveChangesAsync();
                            response.Data = true;
                            response.statusCode = HttpStatusCode.OK;
                            response.Message = "Match ended successfully";
                            transaction.Complete();

                        }
                    }
                    else
                    {
                        response.statusCode = HttpStatusCode.BadRequest;
                        response.Message = "Can't not update match score because this match is end";
                    }
                }
                catch (Exception ex)
                {
                    response.Message = ex.Message;
                    response.statusCode = HttpStatusCode.InternalServerError;
                }
                return response;
            }
        }

        public async Task<StatusResponse<EndMatchResponseDTO>> GetEndMatchDetailsOfBO3(int MatchId)
        {
            var response = new StatusResponse<EndMatchResponseDTO>();
            try
            {
                var data = await _matchesRepo.GetById(MatchId);
                if (data == null)
                {
                    response.Message = "Match not found";
                    response.statusCode = HttpStatusCode.NotFound;
                    return response;
                }
                var matchScores = await _matchScoreRepository.Get().Where(x => x.MatchId == data.Id).ToListAsync();
                if (matchScores == null || matchScores.Count == 0)
                {
                    response.Message = "This Match doesn't start yet";
                    response.statusCode = HttpStatusCode.OK;
                    return response;
                }

                var responseData = new EndMatchResponseDTO
                {
                    MatchId = data.Id,
                    Team1Score = data.Team1Score ?? 0,
                    Team2Score = data.Team2Score ?? 0,
                    Date = data.MatchDate,
                    UrlVideoMatch = data.UrlVideoMatch,
                    Log = data.Log,
                    matchScoreDetails = matchScores.Select(x => new MatchScoreResponseDTO
                    {
                        MatchScoreId = x.MatchScoreId,
                        Round = x.Round,
                        Note = x.Note,
                        CurrentHaft = x.CurrentHaft,
                        Team1Score = x.Team1Score,
                        Team2Score = x.Team2Score
                    }).ToList()
                };
                response.Data = responseData;
                response.statusCode = HttpStatusCode.OK;
                response.Message = "Match details retrieved successfully";
            }
            catch (Exception ex)
            {
                response.Message = ex.Message;
                response.statusCode = HttpStatusCode.InternalServerError;
            }
            return response;
        }

        public async Task<StatusResponse<bool>> UpdateURLEndMatch(int matchId, string url)
        {
            var response = new StatusResponse<bool>();
            try
            {
                var data = await _matchesRepo.GetById(matchId);
                if (data == null)
                {
                    response.Message = "Match not found";
                    response.statusCode = HttpStatusCode.NotFound;
                    return response;
                }
                data.UrlVideoMatch = url;
                _matchesRepo.Update(data);
                await _matchesRepo.SaveChangesAsync();
                response.Data = true;
                response.statusCode = HttpStatusCode.OK;
                response.Message = "URL updated successfully";
            }
            catch (Exception ex)
            {
                response.Message = ex.Message;
                response.statusCode = HttpStatusCode.InternalServerError;
            }
            return response;
        }

        public async Task<StatusResponse<bool>> endMatchCustomOrChallenge(EndMatchNormalRequestDTO dto)
        {
            var response = new StatusResponse<bool>();
            using (var transaction = new TransactionScope(TransactionScopeAsyncFlowOption.Enabled))
                try
                {
                    var data = await _matchesRepo.GetById(dto.MatchId);
                    var teamData = await _teamRepository.GetTeamsWithMatchingIdAsync(dto.MatchId);
                    if (data == null)
                    {
                        response.Message = "Match not found";
                        response.statusCode = HttpStatusCode.NotFound;
                        return response;
                    }
                    if (data.MatchCategory == MatchCategory.Tournament)
                    {
                        response.Message = "This match is tournament match, please use endMatchTourament";
                        response.statusCode = HttpStatusCode.BadRequest;
                        return response;
                    }
                    if (data.Status != MatchStatus.Completed)
                    {
                        data.Status = MatchStatus.Completed;
                        if (dto.Log != null)
                        {
                            data.Log = dto.Log;
                        }
                        bool team1Win = false;
                        bool team2Win = false;

                        if (dto.Team1Score >= (int)data.WinScore && (dto.Team1Score - dto.Team2Score) >= 2)
                        {
                            data.Team1Score = dto.Team1Score;
                            data.Team2Score = dto.Team2Score;
                            team1Win = true;
                        }
                        else if (dto.Team2Score >= (int)data.WinScore && (dto.Team2Score - dto.Team1Score) >= 2)
                        {
                            data.Team1Score = dto.Team1Score;
                            data.Team2Score = dto.Team2Score;
                            team2Win = true;
                        }
                        if (teamData != null && teamData.Count == 2)
                        {
                            var team1 = teamData[0];
                            var team2 = teamData[1];
                            if (data.MatchCategory == MatchCategory.Competitive)
                            {
                                if (team1Win == true)
                                {
                                    await UpdateMatchScoreNormal(team1.Id, team2.Id, team1.Id);
                                }
                                else if (team2Win == true)
                                {
                                    await UpdateMatchScoreNormal(team2.Id, team1.Id, team2.Id);
                                }
                                else
                                {
                                    response.Message = "Bug in BackEnd";
                                    response.statusCode = HttpStatusCode.InternalServerError;
                                    return response;
                                }
                            }
                        }
                    }
                    await _matchesRepo.SaveChangesAsync();
                    response.Data = true;
                    response.statusCode = HttpStatusCode.OK;
                    response.Message = "Match ended successfully";
                    transaction.Complete();
                }
                catch (Exception ex)
                {
                    response.Message = ex.Message;
                    response.statusCode = HttpStatusCode.InternalServerError;
                }
            return response;
        }
        private async Task UpdateMatchScoreNormal(int Team1Id, int team2Id, int WinnerId)
        {
            var team1 = await _teamRepository.GetTeamWithMembersAsync(Team1Id);
            var team2 = await _teamRepository.GetTeamWithMembersAsync(team2Id);

            var allPlayers = team1.Members.Concat(team2.Members).ToList();
            foreach (var member in allPlayers)
            {
                var player = await _playerRepository.GetById(member.PlayerId);
                if (player == null) continue;
                player.TotalMatch++;
                bool isWinner = (WinnerId == Team1Id && team1.Members.Any(m => m.PlayerId == player.PlayerId)) ||
                (WinnerId == team2Id && team2.Members.Any(m => m.PlayerId == player.PlayerId));
                if (isWinner) player.TotalWins++;
                int currentPoint = player.RankingPoint;
                int gain = 0, lose = 0;

                if (currentPoint <= 200) { gain = 20; lose = 10; }
                else if (currentPoint <= 250) { gain = 19; lose = 11; }
                else if (currentPoint <= 300) { gain = 18; lose = 12; }
                else if (currentPoint <= 350) { gain = 17; lose = 13; }
                else if (currentPoint <= 400) { gain = 16; lose = 14; }
                else if (currentPoint <= 450) { gain = 15; lose = 15; }
                else if (currentPoint <= 500) { gain = 14; lose = 16; }
                else if (currentPoint <= 550) { gain = 13; lose = 17; }
                else
                    player.RankingPoint += isWinner ? gain : -lose;
                player.RankingPoint = Math.Max(player.RankingPoint, 0); // Không cho âm điểm
                                                                        // Cập nhật Level nếu cần (có thể gán bằng lại dựa trên điểm)
                player.ExperienceLevel = player.RankingPoint switch
                {
                    <= 200 => 1,
                    <= 250 => 2,
                    <= 300 => 3,
                    <= 350 => 4,
                    <= 400 => 5,
                    <= 450 => 6,
                    <= 500 => 7,
                    <= 550 => 8,
                    _ => 9,
                };
                _playerRepository.Update(player);
            }
            await _playerRepository.SaveChangesAsync();
        }

        public async Task<StatusResponse<MatchResponseDTO>> UpdateMatch(int MatchId, MatchUpdateRequestForNormalMatchRequestDTO dto)
        {
            var response = new StatusResponse<MatchResponseDTO>();
            using (var transaction = new TransactionScope(TransactionScopeAsyncFlowOption.Enabled))
                try
                {
                    var match = await _matchesRepo.Get().Where(x => x.Id == MatchId).SingleOrDefaultAsync();
                    if (match == null)
                    {
                        response.Message = "Match not found";
                        response.statusCode = HttpStatusCode.NotFound;
                        return response;
                    }
                    if (match.Status == MatchStatus.Ongoing || match.Status == MatchStatus.Completed)
                    {
                        response.Message = "Match is ongoing or completed, cannot update!";
                        response.statusCode = HttpStatusCode.BadRequest;
                        return response;
                    }
                    // Apply the values from MatchUpdateRequestDTO
                    if (!string.IsNullOrEmpty(dto.Title))
                        match.Title = dto.Title;

                    if (!string.IsNullOrEmpty(dto.Description))
                        match.Description = dto.Description;

                    if (dto.MatchDate.HasValue)
                        match.MatchDate = dto.MatchDate.Value;

                    if (dto.VenueId.HasValue)
                        match.VenueId = dto.VenueId.Value;

                    if (dto.Status.HasValue)
                        match.Status = dto.Status.Value;

                    if (dto.MatchCategory.HasValue)
                        match.MatchCategory = dto.MatchCategory.Value;
                    if (dto.MatchFormat.HasValue)
                        match.MatchFormat = dto.MatchFormat.Value;
                    if (dto.WinScore.HasValue)
                        match.WinScore = dto.WinScore.Value;
                    if (dto.IsPublic.HasValue)
                        match.IsPublic = dto.IsPublic.Value;
                    if (dto.RefereeId.HasValue)
                        match.RefereeId = dto.RefereeId.Value;

                    await _matchesRepo.SaveChangesAsync();
                    response.Data = _mapper.Map<MatchResponseDTO>(match);
                    response.statusCode = HttpStatusCode.OK;
                    response.Message = "Match updated successfully!";
                    transaction.Complete();
                }
                catch (Exception ex)
                {
                    response.Message = ex.Message;
                    response.statusCode = HttpStatusCode.InternalServerError;
                }
            return response;
        }

        public async Task<StatusResponse<List<RoomResponseDTO>>> GetAllMatchCompetitiveAndCustom()
        {
            var response = new StatusResponse<List<RoomResponseDTO>>();
            try
            {
                var data = await _matchesRepo.Get()
                    .Include(m => m.Teams)
                        .ThenInclude(t => t.Members)
                    .Where(m =>
                        (m.MatchCategory == MatchCategory.Competitive || m.MatchCategory == MatchCategory.Custom)
                        && m.IsPublic == true && m.MatchDate >= DateTime.UtcNow) 
                    .ToListAsync();
                if (data == null)
                {
                    response.statusCode = HttpStatusCode.OK;
                    response.Message = "No matches found";
                    return response;
                }
                var matchResponses = _mapper.Map<List<RoomResponseDTO>>(data);
                response.Data = matchResponses;
                response.statusCode = HttpStatusCode.OK;
                response.Message = "Matches retrieved successfully!";
            }
            catch (Exception ex)
            {
                response.statusCode = HttpStatusCode.InternalServerError;
                response.Message = ex.Message;
            }
            return response;
        }

        public async Task<StatusResponse<List<MatchHistoryResponseDTO>>> HistoryMatchByUserId(int userId)
        {
            var response = new StatusResponse<List<MatchHistoryResponseDTO>>();
            try
            {
                var matchHistoryByUserId = await _teamRepository.Get()
                    .Include(x => x.Members)
                    .Include(x => x.Matches)
                    .Where(x => x.CaptainId == userId || x.Members.Any(m => m.PlayerId == userId))
                    .Select(t => t.Matches)
                    .Distinct()
                    .ToListAsync();

            }
            catch (Exception ex)
            {
                response.statusCode = HttpStatusCode.InternalServerError;
                response.Message = ex.Message;
            }
            return response;
        }

        public async Task<StatusResponse<bool>> isMatchConfirm(int matchId, int playerId)
        {
            var response = new StatusResponse<bool>();
            try
            {
                var data = await _matchesRepo.GetById(matchId);
                if(data == null || data.MatchCategory != MatchCategory.Competitive)
                {
                    response.statusCode = HttpStatusCode.BadRequest;
                    response.Message = "This match doens't have required to confirm";
                    return response;
                }
                var key = $"match-confirm-{matchId}";

                var confirmedPlayers = _memoryCache.Get<HashSet<int>>(key) ?? new HashSet<int>();
                confirmedPlayers.Add(playerId);

                _memoryCache.Set(key, confirmedPlayers, TimeSpan.FromMinutes(10)); // Xác nhận hết hạn sau 10 phút

                if (confirmedPlayers.Count >= 2)
                {
                    // Cả 2 người đã xác nhận
                    // TODO: Gọi repository để lưu trận đấu vào DB

                    _memoryCache.Remove(key); // Xóa cache sau khi xử lý
                    response.Data = true;
                    response.statusCode = HttpStatusCode.OK;
                    response.Message = "Both player accept successful";
                    return response;
                }
                response.Data = false;
                response.statusCode = HttpStatusCode.OK;
                response.Message = "Have player doesn't accept";
                return response;
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