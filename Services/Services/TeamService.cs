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
    public class TeamService : ITeamService
    {
        private readonly ITeamRepository _teamRepo;
        private readonly ITeamMembersService _teamMembersService;

        public TeamService(ITeamRepository teamRepo, ITeamMembersService teamMembersService)
        {
            _teamRepo = teamRepo;
            _teamMembersService = teamMembersService;
        }

        public async Task<StatusResponse<TeamResponseDTO>> GetTeamWithMembersAsync(int teamId)
        {
            var response = new StatusResponse<TeamResponseDTO>();
            try
            {
                var team = await _teamRepo.GetTeamWithMembersAsync(teamId);
                if (team == null)
                {
                    response.statusCode = HttpStatusCode.NotFound;
                    response.Message = "Team not found!";
                    return response;
                }

                var teamResponse = new TeamResponseDTO
                {
                    Id = team.Id,
                    Name = team.Name,
                    Members = team.Members.Select(m => new TeamMemberDTO
                    {
                        Id = m.Id,
                        PlayerId = m.PlayerId,
                    }).ToList()
                };

                response.Data = teamResponse;
                response.statusCode = HttpStatusCode.OK;
                response.Message = "Team retrieved successfully!";
                return response;
            }
            catch (Exception ex)
            {
                response.statusCode = HttpStatusCode.InternalServerError;
                response.Message = ex.Message;
                return response;
            }
        }

        public async Task<StatusResponse<TeamResponseDTO>> CreateTeamAsync(TeamRequestDTO dto)
        {
            var response = new StatusResponse<TeamResponseDTO>();
            try
            {
                var team = new Team
                {
                    Name = dto.Name,
                    CaptainId = dto.CaptainId,
                    MatchingId = dto.MatchingId
                };

                await _teamRepo.AddAsync(team);
                await _teamRepo.SaveChangesAsync();

                var teamResponse = new TeamResponseDTO
                {
                    Id = team.Id,
                    Name = team.Name,
                    CaptainId = team.CaptainId,
                    MatchingId = team.MatchingId
                };

                response.Data = teamResponse;
                response.statusCode = HttpStatusCode.OK;
                response.Message = "Team created successfully!";
                return response;
            }
            catch (Exception ex)
            {
                response.statusCode = HttpStatusCode.InternalServerError;
                response.Message = ex.Message;
                return response;
            }
        }
        public async Task<StatusResponse<List<TeamResponseDTO>>> GetTeamsWithMatchingIdAsync(int matchingId)
        {
            var response = new StatusResponse<List<TeamResponseDTO>>();
            try
            {
                var teams = await _teamRepo.GetTeamsWithMatchingIdAsync(matchingId);
                if (teams == null || !teams.Any())
                {
                    response.statusCode = HttpStatusCode.NotFound;
                    response.Message = "No teams found for the matching ID!";
                    return response;
                }

                var teamResponses = teams.Select(team => new TeamResponseDTO
                {
                    Id = team.Id,
                    Name = team.Name,
                    CaptainId = team.CaptainId,
                    MatchingId = team.MatchingId,
                    Members = team.Members.Select(m => new TeamMemberDTO
                    {
                        Id = m.Id,
                        PlayerId = m.PlayerId,
                    }).ToList()
                }).ToList();

                response.Data = teamResponses;
                response.statusCode = HttpStatusCode.OK;
                response.Message = "Teams retrieved successfully!";
                return response;
            }
            catch (Exception ex)
            {
                response.statusCode = HttpStatusCode.InternalServerError;
                response.Message = ex.Message;
                return response;
            }
        }

        public async Task<StatusResponse<TeamResponseDTO>> GetTeamByIdAsync(int teamId)
        {
            var response = new StatusResponse<TeamResponseDTO>();
            try
            {
                var team = await _teamRepo.GetByIdAsync(teamId);
                if (team == null)
                {
                    response.statusCode = HttpStatusCode.NotFound;
                    response.Message = "Team not found!";
                    return response;
                }
                var teamResponse = new TeamResponseDTO
                {
                    Id = team.Id,
                    Name = team.Name,
                    Members = team.Members.Select(m => new TeamMemberDTO
                    {
                        Id = m.Id,
                        PlayerId = m.PlayerId,
                    }).ToList()
                };



                response.Data = teamResponse;
                response.statusCode = HttpStatusCode.OK;
                response.Message = "Team retrieved successfully!";
                return response;
            }
            catch (Exception ex)
            {
                response.statusCode = HttpStatusCode.InternalServerError;
                response.Message = ex.Message;
                return response;
            }
        }

        public async Task<StatusResponse<bool>> DeleteTeamAsync(int teamId)
        {
            var response = new StatusResponse<bool>();
            try
            {
                var team = await _teamRepo.GetByIdAsync(teamId);
                if (team == null)
                {
                    response.statusCode = HttpStatusCode.NotFound;
                    response.Message = "Team not found!";
                    return response;
                }

                _teamRepo.Delete(team);
                await _teamRepo.SaveChangesAsync();

                response.Data = true;
                response.statusCode = HttpStatusCode.OK;
                response.Message = "Team deleted successfully!";
                return response;
            }
            catch (Exception ex)
            {
                response.statusCode = HttpStatusCode.InternalServerError;
                response.Message = ex.Message;
                return response;
            }
        }

        public async Task<StatusResponse<TeamResponseDTO>> UpdateTeamAsync(int teamId, TeamRequestDTO dto)
        {
            var response = new StatusResponse<TeamResponseDTO>();
            try
            {
                var team = await _teamRepo.GetByIdAsync(teamId);
                if (team == null)
                {
                    response.statusCode = HttpStatusCode.NotFound;
                    response.Message = "Team not found!";
                    return response;
                }

                if (dto.Name != null)
                {
                    team.Name = dto.Name;
                }

                if (dto.CaptainId.HasValue)
                {
                    team.CaptainId = dto.CaptainId.Value;
                }

                if (dto.MatchingId != 0)
                {
                    team.MatchingId = dto.MatchingId;
                }

                _teamRepo.Update(team);
                await _teamRepo.SaveChangesAsync();

                var teamResponse = new TeamResponseDTO
                {
                    Id = team.Id,
                    Name = team.Name,
                    CaptainId = team.CaptainId,
                    MatchingId = team.MatchingId,
                    Members = team.Members.Select(m => new TeamMemberDTO
                    {
                        Id = m.Id,
                        PlayerId = m.PlayerId,
                    }).ToList()
                };

                response.Data = teamResponse;
                response.statusCode = HttpStatusCode.OK;
                response.Message = "Team updated successfully!";
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