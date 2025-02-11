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
        public async Task<StatusResponse<CreateRoomResponseDTO>> CreateRoomAsync(CreateRoomDTO dto)
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
                var createRoomResponse = new CreateRoomResponseDTO
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

                return new StatusResponse<CreateRoomResponseDTO>
                {
                    statusCode = HttpStatusCode.OK,
                    Data = createRoomResponse,
                    Message = "Room created successfully"
                };
            }

            return new StatusResponse<CreateRoomResponseDTO>
            {
                statusCode = response.statusCode,
                Data = null,
                Message = response.Message
            };
        }
    }
}