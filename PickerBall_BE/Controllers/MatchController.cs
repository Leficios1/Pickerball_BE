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

        public MatchController(IMatchService matchService, ITeamService teamService,
            ITeamMembersService teamMembersService)
        {
            _matchService = matchService;
            _teamService = teamService;
            _teamMembersService = teamMembersService;
        }

        [HttpPost("create")]
        public async Task<StatusResponse<RoomResponseDTO>> CreateRoomAsync(CreateRoomDTO dto)
        {
            var room = new MatchRequestDTO
            {
                Title = dto.Title,
                Description = dto.Description,
                MatchDate = dto.MatchDate,
                VenueId = dto.VenueId ?? 0, // Handle null value
                Status = dto.Status,
                MatchCategory = dto.MatchCategory,
                MatchFormat = dto.MatchFormat,
                IsPublic = dto.IsPublic,
                RefereeId = dto.RefereeId
            };
            var response = await _matchService.CreateRoomAsync(room);

            if (response.statusCode == HttpStatusCode.OK)
            {
                var createRoomResponse = new RoomResponseDTO
                {
                    RoomId = response.Data.Id,
                    Title = response.Data.Title,
                    Description = response.Data.Description,
                    MatchDate = response.Data.MatchDate,
                    VenueId = response.Data.VenueId,
                    Status = response.Data.Status,
                    MatchCategory = response.Data.MatchCategory,
                    MatchFormat = response.Data.MatchFormat,
                    IsPublic = response.Data.IsPublic,
                    RefereeId = response.Data.RefereeId,
                    Teams = new List<TeamResponseDTO>()
                };

                // Create teams for the matching room
                var team1Request = new TeamRequestDTO
                {
                    Name = "Team 1",
                    MatchingId = response.Data.Id
                };
                var team1Response = await _teamService.CreateTeamAsync(team1Request);

                var team2Request = new TeamRequestDTO
                {
                    Name = "Team 2",
                    MatchingId = response.Data.Id
                };
                var team2Response = await _teamService.CreateTeamAsync(team2Request);

                if (team1Response.statusCode == HttpStatusCode.OK && team2Response.statusCode == HttpStatusCode.OK)
                {
                    var teamMembers = new List<TeamMemberRequestDTO>();

                    if (dto.MatchFormat == MatchFormat.Team)
                    {
                        if (dto.Player1Id.HasValue)
                            teamMembers.Add(new TeamMemberRequestDTO
                                { TeamId = team1Response.Data.Id, PlayerId = dto.Player1Id.Value });
                        if (dto.Player2Id.HasValue)
                            teamMembers.Add(new TeamMemberRequestDTO
                                { TeamId = team1Response.Data.Id, PlayerId = dto.Player2Id.Value });
                        if (dto.Player3Id.HasValue)
                            teamMembers.Add(new TeamMemberRequestDTO
                                { TeamId = team2Response.Data.Id, PlayerId = dto.Player3Id.Value });
                        if (dto.Player4Id.HasValue)
                            teamMembers.Add(new TeamMemberRequestDTO
                                { TeamId = team2Response.Data.Id, PlayerId = dto.Player4Id.Value });
                    }
                    else // Single
                    {
                        if (dto.Player1Id.HasValue)
                            teamMembers.Add(new TeamMemberRequestDTO
                                { TeamId = team1Response.Data.Id, PlayerId = dto.Player1Id.Value });
                        if (dto.Player2Id.HasValue)
                            teamMembers.Add(new TeamMemberRequestDTO
                                { TeamId = team2Response.Data.Id, PlayerId = dto.Player2Id.Value });
                    }

                    foreach (var member in teamMembers)
                    {
                        await _teamMembersService.CreateTeamMemberAsync(member);
                    }

                    // Add teams and players to the response DTO
                    createRoomResponse.Teams.Add(new TeamResponseDTO
                    {
                        Id = team1Response.Data.Id,
                        Name = team1Response.Data.Name,
                        Members = teamMembers
                            .Where(m => m.TeamId == team1Response.Data.Id)
                            .Select(m => new TeamMemberDTO()
                            {
                                PlayerId = m.PlayerId, Id = m.TeamId
                            })
                            .ToList()
                    });

                    createRoomResponse.Teams.Add(new TeamResponseDTO
                    {
                        Id = team2Response.Data.Id,
                        Name = team2Response.Data.Name,
                        Members = teamMembers
                            .Where(m => m.TeamId == team2Response.Data.Id)
                            .Select(m => new TeamMemberDTO()
                            {
                                PlayerId = m.PlayerId, Id = m.TeamId
                            }) // Replace "Player Name" with actual player name
                            .ToList()
                    });
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

        [HttpGet("all")]
        public async Task<StatusResponse<List<RoomResponseDTO>>> GetAllMatchingsAsync()
        {
            var response = await _matchService.GetPublicRoomsAsync();

            if (response.statusCode == HttpStatusCode.OK)
            {
                var matchings = new List<RoomResponseDTO>();

                foreach (var match in response.Data)
                {
                    var roomResponse = new RoomResponseDTO
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

                    var team1 = await _teamService.GetTeamWithMatchingIdAsync(match.Id);
                    if (team1 != null)
                    {
                        var team1Members = await _teamMembersService.GetTeamMembersByTeamIdAsync(team1.Data.Id);
                        if (team1Members != null)
                        {
                            roomResponse.Teams.Add(new TeamResponseDTO
                            {
                                Id = team1.Data.Id,
                                CaptainId = team1.Data.CaptainId,
                                MatchingId = team1.Data.MatchingId,
                                Members = team1Members?.Data.Select(tm => new TeamMemberDTO
                                {
                                    Id = tm.Id,
                                    PlayerId = tm.PlayerId
                                }).ToList()
                            });
                        }
                   
                    }                    var team2 = await _teamService.GetTeamWithMatchingIdAsync(match.Id);
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
                                Members = team2MembersResponse.Data.Select(tm => new TeamMemberDTO
                                {
                                    Id = tm.Id,
                                    PlayerId = tm.PlayerId
                                }).ToList()
                            });
                        }
                    }

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
    }
}