using AutoMapper;
using Database.DTO.Request;
using Database.DTO.Response;
using Database.Model;
using Microsoft.EntityFrameworkCore;
using Repository.Repository.Interfeace;
using Services.Services.Interface;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;

namespace Services.Services
{
    public class TouramentRegistrationServices : ITouramentRegistrationServices
    {
        private readonly ITournamentRegistrationRepository _tournamentRegistrationRepository;
        private readonly ITouramentRepository _touramentRepository;
        private readonly IPlayerRepository _playerRepository;
        private readonly IMapper _mapper;
        public TouramentRegistrationServices(ITournamentRegistrationRepository tournamentRegistrationRepository, IMapper mapper, ITouramentRepository touramentRepository
            , IPlayerRepository playerRepository)
        {
            _tournamentRegistrationRepository = tournamentRegistrationRepository;
            _touramentRepository = touramentRepository;
            _playerRepository = playerRepository;
            _mapper = mapper;
        }

        public async Task<StatusResponse<TouramentRegistraionResponseDTO>> AcceptPlayer(int PlayerId, TouramentregistrationStatus isAccept, int touramentId)
        {
            var response = new StatusResponse<TouramentRegistraionResponseDTO>();
            try
            {
                var data = await _tournamentRegistrationRepository.getByPlayerIdAndTournamentId(PlayerId, touramentId);
                if (data == null)
                {

                    response.statusCode = HttpStatusCode.NotFound;
                    response.Message = "Player not found!";
                    return response;
                }
                data.IsApproved = isAccept;
                _tournamentRegistrationRepository.Update(data);
                await _tournamentRegistrationRepository.SaveChangesAsync();
                response.Data = _mapper.Map<TouramentRegistraionResponseDTO>(data);
                response.statusCode = HttpStatusCode.OK;
                response.Message = "Change status player successfully!";
            }
            catch (Exception ex)
            {
                response.statusCode = HttpStatusCode.InternalServerError;
                response.Message = ex.Message;
            }
            return response;
        }

        public async Task<StatusResponse<int>> CountTeamJoin(int TouramentId)
        {
            var response = new StatusResponse<int>();
            try
            {
                var data = await _tournamentRegistrationRepository.Get().Where(tr => tr.TournamentId == TouramentId && tr.IsApproved == TouramentregistrationStatus.Approved).CountAsync();
                response.Data = data;
                response.statusCode = HttpStatusCode.OK;
                response.Message = "Count team join successfully!";
            }
            catch (Exception ex)
            {
                response.statusCode = HttpStatusCode.InternalServerError;
                response.Message = ex.Message;
            }
            return response;
        }

        public async Task<StatusResponse<TouramentRegistraionResponseDTO>> CreateRegistration(TouramentRegistrationDTO dto)
        {
            var response = new StatusResponse<TouramentRegistraionResponseDTO>();
            try
            {
                var flag = await _tournamentRegistrationRepository.getByPlayerIdAndTournamentId(dto.PlayerId, dto.TournamentId);
                var isPartnerRegistered = dto.PartnerId.HasValue
                    ? await _tournamentRegistrationRepository.Find(tr => tr.PartnerId == dto.PartnerId.Value && tr.TournamentId == dto.TournamentId)
                    : null;
                var isPlayerRegister = dto.PartnerId.HasValue
                    ? await _tournamentRegistrationRepository.Find(tr => tr.PlayerId == dto.PartnerId.Value && tr.TournamentId == dto.TournamentId)
                    : null;
                if (flag != null || (isPartnerRegistered != null && isPartnerRegistered.Any()) || (isPlayerRegister != null && isPlayerRegister.Any()))
                {
                    response.Data = _mapper.Map<TouramentRegistraionResponseDTO>(flag);
                    response.statusCode = HttpStatusCode.OK;
                    response.Message = "Player already registered!";
                    return response;
                }
                var touramentData = await _touramentRepository.GetById(dto.TournamentId);
                if (touramentData == null)
                {
                    response.statusCode = HttpStatusCode.NotFound;
                    response.Message = "Tournament not found!";
                    return response;
                }
                var acceptedCount = await _tournamentRegistrationRepository.Get()
                    .Where(tr => tr.TournamentId == dto.TournamentId && tr.IsApproved == TouramentregistrationStatus.Pending).CountAsync();
                if (acceptedCount >= touramentData.MaxPlayer)
                {
                    response.statusCode = HttpStatusCode.BadRequest;
                    response.Message = "Tourament is full";
                    return response;
                }

                var playerData = await _playerRepository.GetById(dto.PlayerId);
                TournamentRegistration data;
                if (touramentData.Type == TournamentType.DoublesFemale || touramentData.Type == TournamentType.DoublesMale || touramentData.Type == TournamentType.DoublesMix)
                {
                    var partnerData = dto.PartnerId.HasValue ? await _playerRepository.GetById(dto.PartnerId.Value) : null;
                    if (playerData == null || partnerData == null)
                    {
                        response.statusCode = HttpStatusCode.NotFound;
                        response.Message = "Player or Partner not found!";
                        return response;
                    }
                    else if (playerData.ExperienceLevel < touramentData.IsMinRanking ||
                             playerData.ExperienceLevel > touramentData.IsMaxRanking ||
                             partnerData.ExperienceLevel < touramentData.IsMinRanking ||
                             partnerData.ExperienceLevel > touramentData.IsMaxRanking)
                    {
                        response.statusCode = HttpStatusCode.BadRequest;
                        response.Message = "Player or Partner does not meet the experience requirements for the tournament!";
                        return response;
                    }

                    data = new TournamentRegistration()
                    {
                        PlayerId = dto.PlayerId,
                        TournamentId = dto.TournamentId,
                        RegisteredAt = DateTime.UtcNow,
                        PartnerId = dto.PartnerId,
                        IsApproved = TouramentregistrationStatus.Waiting,
                    };
                }
                else
                {
                    if (playerData == null)
                    {
                        response.statusCode = HttpStatusCode.NotFound;
                        response.Message = "Player not found!";
                        return response;
                    }
                    else if (playerData.ExperienceLevel < touramentData.IsMinRanking ||
                             playerData.ExperienceLevel > touramentData.IsMaxRanking)
                    {
                        response.statusCode = HttpStatusCode.BadRequest;
                        response.Message = "Player does not meet the experience requirements for the tournament!";
                        return response;
                    }
                    
                    data = new TournamentRegistration()
                    {
                        PlayerId = dto.PlayerId,
                        TournamentId = dto.TournamentId,
                        RegisteredAt = DateTime.UtcNow,
                        IsApproved = TouramentregistrationStatus.Pending,
                    };
                    if(touramentData.IsFree == false)
                    {
                        data.IsApproved = TouramentregistrationStatus.Approved;
                    }
                }
                await _tournamentRegistrationRepository.AddAsync(data);
                await _tournamentRegistrationRepository.SaveChangesAsync();
                response.Data = _mapper.Map<TouramentRegistraionResponseDTO>(data);
                response.statusCode = HttpStatusCode.OK;
                response.Message = "Registration Created Successfully";
            }
            catch (Exception ex)
            {
                response.statusCode = HttpStatusCode.InternalServerError;
                response.Message = ex.Message;
            }
            return response;
        }

        public async Task<StatusResponse<List<TouramentRegistraionResponseDTO>>> GetAll()
        {
            var response = new StatusResponse<List<TouramentRegistraionResponseDTO>>();
            try
            {
                var data = await _tournamentRegistrationRepository.GetAll();
                response.Data = _mapper.Map<List<TouramentRegistraionResponseDTO>>(data);
                response.statusCode = HttpStatusCode.OK;
                response.Message = "Get all registration successfully!";

            }
            catch (Exception ex)
            {
                response.statusCode = HttpStatusCode.InternalServerError;
                response.Message = ex.Message;
            }
            return response;
        }

        public async Task<StatusResponse<TouramentRegistraionResponseDTO>> GetById(int id)
        {
            var response = new StatusResponse<TouramentRegistraionResponseDTO>();
            try
            {
                var data = await _tournamentRegistrationRepository.GetById(id);
                if (data == null)
                {
                    response.statusCode = HttpStatusCode.NotFound;
                    response.Message = "Registration not found!";
                    return response;
                }
                response.Data = _mapper.Map<TouramentRegistraionResponseDTO>(data);
                response.statusCode = HttpStatusCode.OK;
                response.Message = "Get registration successfully!";
            }
            catch (Exception ex)
            {
                response.statusCode = HttpStatusCode.InternalServerError;
                response.Message = ex.Message;
            }
            return response;
        }

        public async Task<StatusResponse<List<TouramentRegistraionResponseDTO>>> GetByTouramentId(int TourId)
        {
            var response = new StatusResponse<List<TouramentRegistraionResponseDTO>>();
            try
            {
                var data = await _tournamentRegistrationRepository.Get().Where(tr => tr.TournamentId == TourId).ToListAsync();
                if (data == null)
                {
                    response.statusCode = HttpStatusCode.NotFound;
                    response.Message = "This tourament doesn't have player";
                    return response;
                }
                response.Data = _mapper.Map<List<TouramentRegistraionResponseDTO>>(data);
                response.statusCode = HttpStatusCode.OK;
                response.Message = "Get all registration successfully!";
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
