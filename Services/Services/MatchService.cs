using System.Net;
using AutoMapper;
using Database.DTO.Request;
using Database.DTO.Response;
using Database.Model;
using Repository.Repository.Interface;
using Services.Services.Interface;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Services.Services
{
    public class MatchService : IMatchService
    {
        private readonly IMatchesRepository _matchesRepo;
        private readonly IMapper _mapper;
        private readonly ITeamService _teamService;
        private readonly ITeamMembersService _teamMembersService;

        public MatchService(IMatchesRepository matchesRepo, IMapper mapper, ITeamService teamService,
            ITeamMembersService teamMembersService)
        {
            _matchesRepo = matchesRepo;
            _mapper = mapper;
            _teamService = teamService;
            _teamMembersService = teamMembersService;
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
                RefereeId = dto.RefereeId
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
            var teamResponse = await _teamService.GetTeamByIdAsync(teamId);
            var teamMembersResponse = await _teamMembersService.GetTeamMembersByTeamIdAsync(teamId);

            return new TeamResponseDTO
            {
                Id = teamResponse.Data.Id,
                Name = teamResponse.Data.Name,
                CaptainId = teamResponse.Data.CaptainId,
                MatchingId = teamResponse.Data.MatchingId,
                Members = _mapper.Map<List<TeamMemberDTO>>(teamMembersResponse.Data)
            };
        }

        public async Task<StatusResponse<MatchResponseDTO>> CreateRoomAsync(MatchRequestDTO dto)
        {
            var response = new StatusResponse<MatchResponseDTO>();
            try
            {
                var match = _mapper.Map<Matches>(dto);
                await _matchesRepo.AddAsync(match);
                await _matchesRepo.SaveChangesAsync();

                response.Data = _mapper.Map<MatchResponseDTO>(match);
                response.statusCode = HttpStatusCode.OK;
                response.Message = "Room created successfully!";
                return response;
            }
            catch (Exception ex)
            {
                return CreateErrorResponse<MatchResponseDTO>(HttpStatusCode.InternalServerError, ex.Message);
            }
        }

        public async Task<StatusResponse<RoomResponseDTO>> GetRoomByIdAsync(int id)
        {
            var response = new StatusResponse<RoomResponseDTO>();
            try
            {
                var match = await _matchesRepo.GetByIdAsync(id);
                if (match == null)
                {
                    return CreateErrorResponse<RoomResponseDTO>(HttpStatusCode.NotFound, "Room not found!");
                }

                var matchResponse = _mapper.Map<RoomResponseDTO>(match);
                await PopulateTeamsForMatchResponse(matchResponse);

                response.Data = matchResponse;
                response.statusCode = HttpStatusCode.OK;
                response.Message = "Room retrieved successfully!";
                return response;
            }
            catch (Exception ex)
            {
                return CreateErrorResponse<RoomResponseDTO>(HttpStatusCode.InternalServerError, ex.Message);
            }
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
                var matchResponses = _mapper.Map<IEnumerable<MatchResponseDTO>>(matches);

                response.Data = matchResponses;
                response.statusCode = HttpStatusCode.OK;
                response.Message = "Public rooms retrieved successfully!";
                return response;
            }
            catch (Exception ex)
            {
                return CreateErrorResponse<IEnumerable<MatchResponseDTO>>(HttpStatusCode.InternalServerError, ex.Message);
            }
        }
        public async Task<StatusResponse<IEnumerable<RoomResponseDTO>>> GetAllPublicRoomsAsync()
        {
            var response = new StatusResponse<IEnumerable<RoomResponseDTO>>();
            try
            {
                var matches = await _matchesRepo.GetRoomsByPublicStatusAsync(true); 
                var matchResponses = _mapper.Map<IEnumerable<RoomResponseDTO>>(matches);

                foreach (var matchResponse in matchResponses)
                {
                    await PopulateTeamsForMatchResponse(matchResponse);
                }

                response.Data = matchResponses;
                response.statusCode = HttpStatusCode.OK;
                response.Message = "Public rooms retrieved successfully!";
                return response;
            }
            catch (Exception ex)
            {
                return CreateErrorResponse<IEnumerable<RoomResponseDTO>>(HttpStatusCode.InternalServerError, ex.Message);
            }
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
                            var matchResponse = await _matchesRepo.GetByIdAsync(teamResponse.Data.MatchingId);
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
                var match = await _matchesRepo.GetByIdAsync(id);
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

        public async Task<StatusResponse<MatchResponseDTO>> UpdateRoomAsync(int id, MatchRequestDTO dto)
        {
            var response = new StatusResponse<MatchResponseDTO>();
            try
            {
                var match = await _matchesRepo.GetByIdAsync(id);
                if (match == null)
                {
                    return CreateErrorResponse<MatchResponseDTO>(HttpStatusCode.NotFound, "Room not found!");
                }

                _mapper.Map(dto, match);
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

        private StatusResponse<T> CreateErrorResponse<T>(HttpStatusCode statusCode, string message)
        {
            return new StatusResponse<T>
            {
                statusCode = statusCode,
                Message = message
            };
        }
    }
}