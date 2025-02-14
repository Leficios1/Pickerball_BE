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
            var response = new StatusResponse<RoomResponseDTO>();
            try
            {
                var match = _mapper.Map<Matches>(dto);
                await _matchesRepo.AddAsync(match);
                await _matchesRepo.SaveChangesAsync();

                var createRoomResponse = _mapper.Map<RoomResponseDTO>(match);
                createRoomResponse.Teams = new List<TeamResponseDTO>();

                var team1Response = await _teamService.CreateTeamAsync(new TeamRequestDTO
                    { Name = "Team 1", MatchingId = match.Id });
                var team2Response = await _teamService.CreateTeamAsync(new TeamRequestDTO
                    { Name = "Team 2", MatchingId = match.Id });

                if (team1Response.statusCode == HttpStatusCode.OK && team2Response.statusCode == HttpStatusCode.OK)
                {
                    var teamMembers = _CreateTeamMembers(dto, team1Response.Data.Id, team2Response.Data.Id);
                    foreach (var member in teamMembers) await _teamMembersService.CreateTeamMemberAsync(member);

                    createRoomResponse.Teams.Add(_CreateTeamResponseDTO(team1Response.Data, teamMembers));
                    createRoomResponse.Teams.Add(_CreateTeamResponseDTO(team2Response.Data, teamMembers));
                }

                response.Data = createRoomResponse;
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

        private List<TeamMemberRequestDTO> _CreateTeamMembers(CreateRoomDTO dto, int team1Id, int team2Id)
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

        private TeamResponseDTO _CreateTeamResponseDTO(TeamResponseDTO team, List<TeamMemberRequestDTO> teamMembers)
        {
            return new TeamResponseDTO
            {
                Id = team.Id,
                Name = team.Name,
                Members = _mapper.Map<List<TeamMemberDTO>>(teamMembers.Where(m => m.TeamId == team.Id))
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

                var matchResponse = _mapper.Map<MatchResponseDTO>(match);
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

                var matchResponse = _mapper.Map<MatchResponseDTO>(match);
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
                var matchResponses = _mapper.Map<IEnumerable<MatchResponseDTO>>(matches);

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

        public async Task<StatusResponse<List<RoomResponseDTO>>> GetAllMatchingsAsync()
        {
            var response = new StatusResponse<List<RoomResponseDTO>>();
            try
            {
                var matches = await _matchesRepo.GetAllAsync();
                var matchResponses = _mapper.Map<List<RoomResponseDTO>>(matches);

                foreach (var match in matchResponses)
                {
                    var teamsResponse = await _teamService.GetTeamsWithMatchingIdAsync(match.RoomId);
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
                                match.Teams.Add(teamResponse);
                            }
                        }
                    }
                }

                response.Data = matchResponses;
                response.statusCode = HttpStatusCode.OK;
                response.Message = "Matchings retrieved successfully!";
                return response;
            }
            catch (Exception ex)
            {
                response.statusCode = HttpStatusCode.InternalServerError;
                response.Message = ex.Message;
                return response;
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
                var teamResponse = await _teamService.GetTeamByIdAsync(dto.TeamId);
                if (teamResponse.statusCode == HttpStatusCode.OK)
                {
                    var teamMembersResponse = await _teamMembersService.GetTeamMembersByTeamIdAsync(dto.TeamId);
                    if (teamMembersResponse.statusCode == HttpStatusCode.OK)
                    {
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
                }
            }

            return new StatusResponse<TeamResponseDTO>
            {
                statusCode = response.statusCode,
                Data = null,
                Message = response.Message
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

                _mapper.Map(dto, match);
                _matchesRepo.Update(match);
                await _matchesRepo.SaveChangesAsync();

                var matchResponse = _mapper.Map<MatchResponseDTO>(match);
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
    }
}