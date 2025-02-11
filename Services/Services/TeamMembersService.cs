using Database.DTO.Request;
using Database.DTO.Response;
using Database.Model;
using Repository.Repository.Interface;
using Services.Services.Interface;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Threading.Tasks;

namespace Services.Services
{
    public class TeamMembersService : ITeamMembersService
    {
        private readonly ITeamMembersRepository _teamMembersRepo;

        public TeamMembersService(ITeamMembersRepository teamMembersRepo)
        {
            _teamMembersRepo = teamMembersRepo;
        }

        public async Task<StatusResponse<TeamMemberDTO>> CreateTeamMemberAsync(TeamMemberRequestDTO dto)
        {
            var response = new StatusResponse<TeamMemberDTO>();
            try
            {
                var teamMember = new TeamMembers
                {
                    TeamId = dto.TeamId,
                    PlayerId = dto.PlayerId,
                    JoinedAt = DateTime.UtcNow
                };

                await _teamMembersRepo.AddAsync(teamMember);
                await _teamMembersRepo.SaveChangesAsync();

                var teamMemberResponse = new TeamMemberDTO
                {
                    Id = teamMember.Id,
                    PlayerId = teamMember.PlayerId,
                };

                response.Data = teamMemberResponse;
                response.statusCode = HttpStatusCode.OK;
                response.Message = "Team member created successfully!";
                return response;
            }
            catch (Exception ex)
            {
                response.statusCode = HttpStatusCode.InternalServerError;
                response.Message = ex.Message;
                return response;
            }
        }

        public async Task<StatusResponse<IEnumerable<TeamMemberDTO>>> GetTeamMembersByTeamIdAsync(int teamId)
        {
            var response = new StatusResponse<IEnumerable<TeamMemberDTO>>();
            try
            {
                var teamMembers = await _teamMembersRepo.GetByTeamIdAsync(teamId);
                var teamMemberDTOs = teamMembers.Select(tm => new TeamMemberDTO
                {
                    Id = tm.Id,
                    PlayerId = tm.PlayerId,
                }).ToList();

                response.Data = teamMemberDTOs;
                response.statusCode = HttpStatusCode.OK;
                response.Message = "Team members retrieved successfully!";
                return response;
            }
            catch (Exception ex)
            {
                response.statusCode = HttpStatusCode.InternalServerError;
                response.Message = ex.Message;
                return response;
            }
        }

        public async Task<StatusResponse<IEnumerable<TeamMemberDTO>>> GetTeamMembersByPlayerIdAsync(int playerId)
        {
            var response = new StatusResponse<IEnumerable<TeamMemberDTO>>();
            try
            {
                var teamMembers = await _teamMembersRepo.GetByPlayerIdAsync(playerId);
                if (!teamMembers.Any())
                {
                    response.statusCode = HttpStatusCode.NotFound;
                    response.Message = "Team members not found!";
                    return response;
                }

                var teamMemberDTOs = teamMembers.Select(tm => new TeamMemberDTO
                {
                    Id = tm.Id,
                    PlayerId = tm.PlayerId
                }).ToList();

                response.Data = teamMemberDTOs;
                response.statusCode = HttpStatusCode.OK;
                response.Message = "Team members retrieved successfully!";
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