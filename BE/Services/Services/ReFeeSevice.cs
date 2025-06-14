﻿using Database.Model;
using Repository.Repository.Interface;
using Services.Services.Interface;
using System.Collections.Generic;
using System.Net;
using System.Threading.Tasks;
using System.Transactions;
using AutoMapper;
using Database.DTO.Request;
using Database.DTO.Response;
using Repository.Repository.Interfeace;
using Microsoft.EntityFrameworkCore;
using System.Text.RegularExpressions;

namespace Services.Services
{
    public class ReFeeSevice : IReFeeSevice
    {
        private readonly IRefreeRepository _refreeRepository;
        private readonly ITouramentRepository _touramentRepository;
        private readonly IMatchesRepository _matchRepository;
        private readonly IMapper _mapper;
        private readonly IUserRepository _userRepository;
        private readonly ITeamRepository _teamRepository;

        public ReFeeSevice(IRefreeRepository refreeRepository, ITouramentRepository touramentRepository, IMatchesRepository matchesRepository, IMapper mapper, IUserRepository userRepository,
            ITeamRepository teamRepository)
        {
            _refreeRepository = refreeRepository;
            _touramentRepository = touramentRepository;
            _matchRepository = matchesRepository;
            _mapper = mapper;
            _userRepository = userRepository;
            _teamRepository = teamRepository;
        }

        public async Task<Refree> CreateRefreeAsync(CreateRefreeDTO refreeDto)
        {
            return await _refreeRepository.CreateRefreeAsync(refreeDto);
        }

        public async Task<StatusResponse<Refree>> UpdateRefree(UpdateRefreeDTO dto, int id)
        {
            var response = new StatusResponse<Refree>();

            using (var transaction = new TransactionScope(TransactionScopeAsyncFlowOption.Enabled))
            {
                try
                {
                    var existingRefree = await _refreeRepository.GetById(id);
                    if (existingRefree == null)
                    {
                        return new StatusResponse<Refree>
                        {
                            Message = "Refree not found",
                            statusCode = HttpStatusCode.NotFound
                        };
                    }

                    // Apply the values from UpdateRefreeDTO
                    foreach (var property in typeof(UpdateRefreeDTO).GetProperties())
                    {
                        var value = property.GetValue(dto);
                        if (value != null)
                        {
                            var existingProperty = typeof(Refree).GetProperty(property.Name);
                            if (existingProperty != null)
                            {
                                existingProperty.SetValue(existingRefree, value);
                            }
                        }
                    }

                    _refreeRepository.Update(existingRefree);
                    await _refreeRepository.SaveChangesAsync();

                    response.Data = existingRefree;
                    response.statusCode = HttpStatusCode.OK;
                    response.Message = "Refree Updated Successfully";
                    transaction.Complete();
                }
                catch (Exception ex)
                {
                    response.Message = ex.Message;
                    response.statusCode = HttpStatusCode.InternalServerError;
                }
            }

            return response;
        }

        public async Task<List<Refree>> GetByRefreeCode(string id)
        {
            return await _refreeRepository.GetByRefreeCode(id);
        }

        public async Task<List<Refree>> GetAll()
        {
            return await _refreeRepository.GetAllRefreesAsync();
        }

        public async Task<StatusResponse<List<MatchResponseDTO>>> GetMatchByRefreeCode(int UserId)
        {
            var response = new StatusResponse<List<MatchResponseDTO>>();
            try
            {
                var data = await _matchRepository.Get().Where(x => x.RefereeId == UserId).ToListAsync();
                if (data == null)
                {
                    response.statusCode = HttpStatusCode.OK;
                    response.Message = "Don't have match";
                    return response;
                }
                var matchResponseList = new List<MatchResponseDTO>();
                foreach (var match in data)
                {
                    var teamData = await _teamRepository.GetTeamsWithMatchingIdAsync(match.Id);
                    var teamResponses = teamData.Select(team => new TeamResponseDTO
                    {
                        Id = team.Id,
                        CaptainId = team.CaptainId,
                        MatchingId = team.MatchingId,
                        Name = team.Name,
                        Members = team.Members.Select(m => new TeamMemberDTO
                        {
                            Id = m.Id,
                            PlayerId = m.PlayerId,
                            JoinedAt = m.JoinedAt
                        }).ToList()
                    }).ToList();

                    var matchDto = new MatchResponseDTO
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
                        TeamResponse = teamResponses
                    };

                    matchResponseList.Add(matchDto);
                }
                response.Data = matchResponseList;
                response.statusCode = HttpStatusCode.OK;
                response.Message = "Get match successfully!";
            }
            catch (Exception e)
            {
                response.Message = e.Message;
                response.statusCode = HttpStatusCode.InternalServerError;
            }
            return response;
        }

        public async Task<StatusResponse<List<TournamentResponseDTO>>> GetTouramentByRefreeId(int userId)
        {
            var response = new StatusResponse<List<TournamentResponseDTO>>();
            try
            {
                var data = await _matchRepository.Get().Where(x => x.RefereeId == userId).Include(x => x.TournamentMatches).ThenInclude(tm => tm.Tournament).ToListAsync();
                if (data == null)
                {
                    response.statusCode = HttpStatusCode.OK;
                    response.Message = "Don't have match";
                    return response;
                }
                var tournaments = data
                    .SelectMany(m => m.TournamentMatches)
                    .Select(tm => tm.Tournament)
                    .Where(t => t != null)
                    .Distinct() // nếu cần loại trùng
                    .Select(t => new TournamentResponseDTO
                    {
                        Id = t.Id,
                        Name = t.Name,
                        StartDate = t.StartDate,
                        EndDate = t.EndDate,
                        Location = t.Location,
                        Descreption = t.Descreption,
                        Status = t.Status,
                        Banner = t.Banner,
                        MaxPlayer = t.MaxPlayer,
                        IsFree = t.IsFree,
                        IsMinRanking = t.IsMinRanking,
                        IsMaxRanking = t.IsMaxRanking,
                        Social = t.Social,
                        TotalPrize = t.TotalPrize,
                        Note = t.Note,
                        OrganizerId = t.OrganizerId,
                    }).ToList();
                response.Data = tournaments;
                response.statusCode = HttpStatusCode.OK;
                response.Message = "Get tournament successfully!";
            }
            catch (Exception e)
            {
                response.Message = e.Message;
                response.statusCode = HttpStatusCode.InternalServerError;
            }
            return response;
        }

        public async Task<StatusResponse<List<UserResponseDTO>>> GetAllForMobile()
        {
            var response = new StatusResponse<List<UserResponseDTO>>();
            try
            {
                var data = await _userRepository.Get().Where(x => x.RoleId == 4).ToListAsync();
                if (data == null)
                {
                    response.statusCode = HttpStatusCode.OK;
                    response.Message = "Don't have refree";
                    return response;
                }
                response.Data = _mapper.Map<List<UserResponseDTO>>(data);
                response.statusCode = HttpStatusCode.OK;
                response.Message = "Get refree successfully!";

            }
            catch (Exception e)
            {
                response.Message = e.Message;
                response.statusCode = HttpStatusCode.InternalServerError;
            }
            return response;
        }
    }
}
