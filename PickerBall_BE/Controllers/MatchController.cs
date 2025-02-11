using Database.DTO.Request;
using Microsoft.AspNetCore.Mvc;
using Services.Services.Interface;
using System.Collections.Generic;
using System.Net;
using System.Threading.Tasks;
using Database.DTO.Response;
using Database.Model;

namespace PickerBall_BE.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class MatchController : ControllerBase
    {
        private readonly IMatchService _matchService;
        private readonly ITeamService _teamService;
        private readonly ITeamMembersService _teamMembersService;

        public MatchController(IMatchService matchService, ITeamService teamService, ITeamMembersService teamMembersService)
        {
            _matchService = matchService;
            _teamService = teamService;
            _teamMembersService = teamMembersService;
        }

        [HttpPost("create")]
        public async Task<StatusResponse<RoomResponseDTO>> CreateRoomAsync(CreateRoomDTO dto)
        {
            var response = await _matchService.CreateRoomAsync(MapToMatchRequestDTO(dto));

            if (response.statusCode == HttpStatusCode.OK)
            {
                var createRoomResponse = MapToRoomResponseDTO(response.Data);
                await CreateTeamsAndMembers(dto, createRoomResponse);
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

        [HttpGet("all")]
        public async Task<StatusResponse<List<RoomResponseDTO>>> GetAllMatchingsAsync()
        {
            var response = await _matchService.GetPublicRoomsAsync();

            if (response.statusCode == HttpStatusCode.OK)
            {
                var matchings = new List<RoomResponseDTO>();

                foreach (var match in response.Data)
                {
                    var roomResponse = MapToRoomResponseDTO(match);
                    await AddTeamsToRoomResponse(roomResponse, match.Id);
                    matchings.Add(roomResponse);
                }

                return new StatusResponse<List<RoomResponseDTO>>
                {
                    statusCode = HttpStatusCode.OK,
                    Data = matchings,
                    Message = "Matchings retrieved successfully"
                };
            }

            return new StatusResponse<List<RoomResponseDTO>>
            {
                statusCode = response.statusCode,
                Data = null,
                Message = response.Message
            };
        }

        private MatchRequestDTO MapToMatchRequestDTO(CreateRoomDTO dto)
        {
            return new MatchRequestDTO
            {
                Title = dto.Title,
                Description = dto.Description,
                MatchDate = dto.MatchDate,
                VenueId = dto.VenueId ?? 0,
                Status = dto.Status,
                MatchCategory = dto.MatchCategory,
                MatchFormat = dto.MatchFormat,
                IsPublic = dto.IsPublic,
                RefereeId = dto.RefereeId
            };
        }

        private RoomResponseDTO MapToRoomResponseDTO(MatchResponseDTO match)
        {
            return new RoomResponseDTO
            {
                RoomId = match.Id,
                Title = match.Title,
                Description = match.Description,
                MatchDate = match.MatchDate,
                VenueId = match.VenueId,
                Status = match.Status,
                MatchCategory = match.MatchCategory,
                MatchFormat = match.MatchFormat,
                IsPublic = match.IsPublic,
                RefereeId = match.RefereeId,
                Teams = new List<TeamResponseDTO>()
            };
        }

        private async Task CreateTeamsAndMembers(CreateRoomDTO dto, RoomResponseDTO createRoomResponse)
        {
            var team1Response = await _teamService.CreateTeamAsync(new TeamRequestDTO { Name = "Team 1", MatchingId = createRoomResponse.RoomId });
            var team2Response = await _teamService.CreateTeamAsync(new TeamRequestDTO { Name = "Team 2", MatchingId = createRoomResponse.RoomId });

            if (team1Response.statusCode == HttpStatusCode.OK && team2Response.statusCode == HttpStatusCode.OK)
            {
                var teamMembers = GetTeamMembers(dto, team1Response.Data.Id, team2Response.Data.Id);
                foreach (var member in teamMembers)
                {
                    await _teamMembersService.CreateTeamMemberAsync(member);
                }

                AddTeamsToRoomResponse(createRoomResponse, team1Response.Data, teamMembers);
                AddTeamsToRoomResponse(createRoomResponse, team2Response.Data, teamMembers);
            }
        }

        private List<TeamMemberRequestDTO> GetTeamMembers(CreateRoomDTO dto, int team1Id, int team2Id)
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

        private void AddTeamsToRoomResponse(RoomResponseDTO createRoomResponse, TeamResponseDTO teamResponse, List<TeamMemberRequestDTO> teamMembers)
        {
            createRoomResponse.Teams.Add(new TeamResponseDTO
            {
                Id = teamResponse.Id,
                Name = teamResponse.Name,
                Members = teamMembers
                    .Where(m => m.TeamId == teamResponse.Id)
                    .Select(m => new TeamMemberDTO { PlayerId = m.PlayerId, Id = m.TeamId })
                    .ToList()
            });
        }

        private async Task AddTeamsToRoomResponse(RoomResponseDTO roomResponse, int matchId)
        {
            var team1 = await _teamService.GetTeamWithMatchingIdAsync(matchId);
            if (team1 != null)
            {
                var team1Members = await _teamMembersService.GetTeamMembersByTeamIdAsync(team1.Data.Id);
                if (team1Members.statusCode == HttpStatusCode.OK && team1Members.Data != null)
                {
                    roomResponse.Teams.Add(new TeamResponseDTO
                    {
                        Id = team1.Data.Id,
                        CaptainId = team1.Data.CaptainId,
                        MatchingId = team1.Data.MatchingId,
                        Members = team1Members.Data.Select(tm => new TeamMemberDTO { Id = tm.Id, PlayerId = tm.PlayerId }).ToList()
                    });
                }
            }

            var team2 = await _teamService.GetTeamWithMatchingIdAsync(matchId);
            if (team2 != null)
            {
                var team2MembersResponse = await _teamMembersService.GetTeamMembersByTeamIdAsync(team2.Data.Id);
                if (team2MembersResponse.statusCode == HttpStatusCode.OK && team2MembersResponse.Data != null)
                {
                    roomResponse.Teams.Add(new TeamResponseDTO
                    {
                        Id = team2.Data.Id,
                        Name = team2.Data.Name,
                        CaptainId = team2.Data.CaptainId,
                        MatchingId = team2.Data.MatchingId,
                        Members = team2MembersResponse.Data.Select(tm => new TeamMemberDTO { Id = tm.Id, PlayerId = tm.PlayerId }).ToList()
                    });
                }
            }
        }
    }
}
