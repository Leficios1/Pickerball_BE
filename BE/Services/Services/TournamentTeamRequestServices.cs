﻿using AutoMapper;
using Database.DTO.Request;
using Database.DTO.Response;
using Database.Model;
using Microsoft.EntityFrameworkCore;
using Repository.Repository;
using Repository.Repository.Interfeace;
using Services.Services.Interface;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;
using System.Transactions;

namespace Services.Services
{
    public class TournamentTeamRequestServices : ITournamentTeamRequestServices
    {
        private readonly ITournamentTeamRequestRepository _tournamentTeamRequestRepository;
        private readonly INotificationRepository _notificationRepository;
        private readonly ITournamentRegistrationRepository _tournamentRegistrationRepository;
        private readonly IUserRepository _userRepository;
        private readonly ITouramentRepository _touramentRepository;
        private readonly IMapper _mapper;

        public TournamentTeamRequestServices(ITournamentTeamRequestRepository tournamentTeamRequestRepository, IMapper mapper, INotificationRepository notificationRepository, ITournamentRegistrationRepository tournamentRegistrationRepository,
            ITouramentRepository touramentRepository, IUserRepository userRepository)
        {
            _tournamentTeamRequestRepository = tournamentTeamRequestRepository;
            _mapper = mapper;
            _notificationRepository = notificationRepository;
            _tournamentRegistrationRepository = tournamentRegistrationRepository;
            _touramentRepository = touramentRepository;
            _userRepository = userRepository;
        }

        public async Task<StatusResponse<TouramentRegistraionResponseDTO>> CheckAccept(int userId, int touramentId)
        {
            var response = new StatusResponse<TouramentRegistraionResponseDTO>();
            try
            {
                var data = await _tournamentTeamRequestRepository.Get().Include(t => t.TournamentRegistration).
                    Where(x => x.RequesterId == userId && x.TournamentRegistration.TournamentId == touramentId || x.PartnerId == userId && x.TournamentRegistration.TournamentId == touramentId).SingleOrDefaultAsync();
                if (data == null)
                {
                    response.statusCode = HttpStatusCode.NotFound;
                    response.Message = "Request not found!";
                    return response;
                }
                var responseData = new TouramentRegistraionResponseDTO
                {
                    Id = data.RegistrationId,
                    PlayerId = data.RequesterId,
                    TournamentId = data.TournamentRegistration.TournamentId,
                    PartnerId = data.PartnerId,
                    IsApproved = data.TournamentRegistration.IsApproved,
                    RegisteredAt = data.TournamentRegistration.RegisteredAt,
                    RequestId = data.Id
                };
                response.Data = responseData;
                response.statusCode = HttpStatusCode.OK;
                response.Message = "Get team request successfully!";
            }
            catch (Exception ex)
            {
                response.statusCode = HttpStatusCode.InternalServerError;
                response.Message = ex.Message;
            }
            return response;
        }

        public async Task<StatusResponse<List<TournamentTeamRequestResponseDTO>>> GetTeamRequestByRequestUser(int PlayerId)
        {
            var response = new StatusResponse<List<TournamentTeamRequestResponseDTO>>();
            try
            {
                var data = await _tournamentTeamRequestRepository.Get()
                    .Where(tr => tr.RequesterId == PlayerId)
                    .Include(tr => tr.Requester)
                    .ThenInclude(p => p.User)
                    .Include(tr => tr.TournamentRegistration)
                    .ThenInclude(trr => trr.Tournament)
                    .ToListAsync();
                var result = data.Select(tr => new TournamentTeamRequestResponseDTO
                {
                    Id = tr.Id,
                    RegistrationId = tr.RegistrationId,
                    RequesterId = tr.RequesterId,
                    PartnerId = tr.PartnerId,
                    Status = tr.Status,
                    TournamentId = tr.TournamentRegistration.TournamentId,
                    TournamentName = tr.TournamentRegistration?.Tournament?.Name,
                    RequesterName = tr.Requester?.User?.FirstName + " " + tr.Requester?.User?.LastName,
                    CreatedAt = tr.CreatedAt
                }).ToList();
                response.Data = result;
                response.statusCode = HttpStatusCode.OK;
                response.Message = "Get team request successfully!";
            }
            catch (Exception ex)
            {
                response.statusCode = HttpStatusCode.InternalServerError;
                response.Message = ex.Message;
            }
            return response;
        }

        public async Task<StatusResponse<List<TournamentTeamRequestResponseDTO>>> GetTeamRequestByResponseUser(int PlayerId)
        {
            var response = new StatusResponse<List<TournamentTeamRequestResponseDTO>>();
            try
            {
                var data = await _tournamentTeamRequestRepository.Get()
                    .Where(tr => tr.PartnerId == PlayerId)
                    .Include(tr => tr.Requester)
                        .ThenInclude(p => p.User)
                    .Include(tr => tr.TournamentRegistration)
                        .ThenInclude(trr => trr.Tournament)
                    .ToListAsync();

                var result = data.Select(tr => new TournamentTeamRequestResponseDTO
                {
                    Id = tr.Id,
                    RegistrationId = tr.RegistrationId,
                    RequesterId = tr.RequesterId,
                    PartnerId = tr.PartnerId,
                    TournamentId = tr.TournamentRegistration?.Tournament?.Id,
                    TournamentName = tr.TournamentRegistration?.Tournament?.Name,
                    RequesterName = tr.Requester?.User?.FirstName + " " + tr.Requester?.User?.LastName,
                    Status = tr.Status,
                    CreatedAt = tr.CreatedAt
                }).ToList();
                response.Data = result;
                response.statusCode = HttpStatusCode.OK;
                response.Message = "Get team request successfully!";
            }
            catch (Exception ex)
            {
                response.statusCode = HttpStatusCode.InternalServerError;
                response.Message = ex.Message;
            }
            return response;
        }

        public async Task<StatusResponse<bool>> RespondToTeamRequest(int requestId, bool isAccept)
        {
            var response = new StatusResponse<bool>();
            using (var transaction = new TransactionScope(TransactionScopeAsyncFlowOption.Enabled))
            {
                try
                {
                    var request = await _tournamentTeamRequestRepository.GetById(requestId);
                    if (request == null)
                    {
                        response.statusCode = HttpStatusCode.NotFound;
                        response.Message = "Request not found!";
                        return response;
                    }

                    var registration = await _tournamentRegistrationRepository.GetById(request.RegistrationId);
                    if (registration == null)
                    {
                        response.statusCode = HttpStatusCode.NotFound;
                        response.Message = "Registration not found!";
                        return response;
                    }
                    var tournament = await _touramentRepository.GetById(registration.TournamentId);
                    if (tournament == null)
                    {
                        response.statusCode = HttpStatusCode.NotFound;
                        response.Message = "Tournament not found!";
                        return response;
                    }
                    if (isAccept)
                    {
                        request.Status = TournamentRequestStatus.Accepted;

                        // ✅ Cập nhật TournamentRegistration
                        registration.PartnerId = request.PartnerId;
                        registration.IsApproved = TouramentregistrationStatus.Pending;
                        _tournamentRegistrationRepository.Update(registration);
                        var notification = new Notification
                        {
                            UserId = request.RequesterId,
                            Message = "Your team invitation was accepted.",
                            CreatedAt = DateTime.UtcNow,
                            IsRead = false,
                            Type = NotificationType.AccpetTournamentTeamRequest,
                            ReferenceId = tournament.Id // Tham chiếu đến Tournament
                        };
                        var dataTourament = await _touramentRepository.GetById(registration.TournamentId);
                        if (dataTourament.IsFree == false)
                        {
                            registration.IsApproved = TouramentregistrationStatus.Approved;
                        }
                        await _notificationRepository.AddAsync(notification);
                        await _notificationRepository.SaveChangesAsync();
                        await _tournamentRegistrationRepository.SaveChangesAsync();
                    }
                    else
                    {
                        request.Status = TournamentRequestStatus.Rejected;

                        // ✅ Xóa Registration nếu cần
                        _tournamentRegistrationRepository.Delete(registration);
                        await _tournamentRegistrationRepository.SaveChangesAsync();

                        // ✅ Gửi thông báo đến Requester
                        var notification = new Notification
                        {
                            UserId = request.RequesterId,
                            Message = "Your team invitation was rejected.",
                            CreatedAt = DateTime.UtcNow,
                            IsRead = false,
                            Type = NotificationType.AccpetTournamentTeamRequest,
                            ReferenceId = tournament.Id // Tham chiếu đến Tournament
                        };
                        await _notificationRepository.AddAsync(notification);
                        await _notificationRepository.SaveChangesAsync();
                    }

                    //_tournamentTeamRequestRepository.Update(request);
                    await _tournamentTeamRequestRepository.SaveChangesAsync();

                    response.Data = true;
                    response.statusCode = HttpStatusCode.OK;
                    response.Message = isAccept ? "Invitation accepted!" : "Invitation rejected!";
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

        public async Task<StatusResponse<bool>> SendTeamRequest(TournamentTeamRequestDTO dto)
        {
            var response = new StatusResponse<bool>();
            using (var transaction = new TransactionScope(TransactionScopeAsyncFlowOption.Enabled))
            {
                try
                {
                    var existingRequest = await _tournamentTeamRequestRepository.Get()
                        .Where(tr => tr.RegistrationId == dto.RegistrationId && tr.PartnerId == dto.RecevierId)
                        .FirstOrDefaultAsync();

                    if (existingRequest != null)
                    {
                        response.statusCode = HttpStatusCode.BadRequest;
                        response.Message = "Invitation already sent!";
                        return response;
                    }

                    var request = new TournamentTeamRequest
                    {
                        RegistrationId = dto.RegistrationId,
                        RequesterId = dto.RequesterId,
                        PartnerId = dto.RecevierId,
                        Status = TournamentRequestStatus.Pending
                    };
                    var registration = await _tournamentRegistrationRepository.GetById(dto.RegistrationId);
                    if (registration == null)
                    {
                        response.statusCode = HttpStatusCode.NotFound;
                        response.Message = "Registration not found!";
                        return response;
                    }

                    var tourament = await _touramentRepository.GetById(registration.TournamentId);
                    if (tourament == null)
                    {
                        response.statusCode = HttpStatusCode.NotFound;
                        response.Message = "Tournament not found!";
                        return response;
                    }

                    await _tournamentTeamRequestRepository.AddAsync(request);
                    await _tournamentTeamRequestRepository.SaveChangesAsync();

                    var dataRequester = await _userRepository.GetById(dto.RequesterId);

                    // Gửi thông báo đến Partner
                    var notification = new Notification
                    {
                        UserId = dto.RecevierId,
                        Message = $"You have received a tournament invitation from {dataRequester.LastName}.",
                        CreatedAt = DateTime.UtcNow,
                        IsRead = false,
                        Type = NotificationType.TournamentTeamRequest,
                        ReferenceId = request.Id, // Tham chiếu đến TournamentTeamRequest
                        BonusId = tourament.Id // Tham chiếu đến Tournament
                    };
                    await _notificationRepository.AddAsync(notification);
                    await _notificationRepository.SaveChangesAsync();

                    response.Data = true;
                    response.statusCode = HttpStatusCode.OK;
                    response.Message = "Team invitation sent successfully!";
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
    }
}
