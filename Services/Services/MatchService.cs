
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


        public MatchService(IMatchesRepository matchesRepo, IMapper mapper, ITeamService teamService,
            ITeamMembersService teamMembersService, ITouramentMatchesRepository touramentMatchesRepository,
            ITouramentRepository touramentRepository, ITeamRepository teamRepository, ITeamMembersRepository teamMembersRepository)
        {
            _matchesRepo = matchesRepo;
            _mapper = mapper;
            _teamService = teamService;
            _teamMembersService = teamMembersService;
            _touramentMatchesRepository = touramentMatchesRepository;
            _touramentRepository = touramentRepository;
            _teamRepository = teamRepository;
            _teamMembersRepository = teamMembersRepository;
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

                var team1Response = await CreateTeamForRoom(response.Data.Id, "Team 1", dto.Player1Id);
                var team2Response = await CreateTeamForRoom(response.Data.Id, "Team 2", dto.Player2Id);

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

        private async Task<StatusResponse<TeamResponseDTO>> CreateTeamForRoom(int roomId, string teamName, int? CaptainId)
        {
            var teamRequest = new TeamRequestDTO { Name = teamName, MatchingId = roomId, CaptainId = CaptainId };
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
                    response.statusCode = HttpStatusCode.NotFound;
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
                    if(!match.IsPublic)
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
                    int maxPlayers = match.MatchFormat == MatchFormat.Team ? 4 : 2;
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
                    if (match.MatchFormat == MatchFormat.Team)
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

    }
}