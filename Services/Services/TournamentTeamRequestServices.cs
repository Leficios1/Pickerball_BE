using AutoMapper;
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
        private readonly IMapper _mapper;

        public TournamentTeamRequestServices(ITournamentTeamRequestRepository tournamentTeamRequestRepository, IMapper mapper, INotificationRepository notificationRepository, ITournamentRegistrationRepository tournamentRegistrationRepository)
        {
            _tournamentTeamRequestRepository = tournamentTeamRequestRepository;
            _mapper = mapper;
            _notificationRepository = notificationRepository;
            _tournamentRegistrationRepository = tournamentRegistrationRepository;
        }

        public async Task<StatusResponse<List<TournamentTeamRequestResponseDTO>>> GetTeamRequestByRequestUser(int PlayerId)
        {
            var response = new StatusResponse<List<TournamentTeamRequestResponseDTO>>();
            try
            {
                var data = await _tournamentTeamRequestRepository.Get()
                    .Where(tr => tr.RequesterId == PlayerId)
                    .Select(tr => new TournamentTeamRequestResponseDTO
                    {
                        Id = tr.Id,
                        RegistrationId = tr.RegistrationId,
                        RequesterId = tr.RequesterId,
                        PartnerId = tr.PartnerId,
                        Status = tr.Status
                    })
                    .ToListAsync();
                response.Data = data;
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
                    .Select(tr => new TournamentTeamRequestResponseDTO
                    {
                        Id = tr.Id,
                        RegistrationId = tr.RegistrationId,
                        RequesterId = tr.RequesterId,
                        PartnerId = tr.PartnerId,
                        Status = tr.Status
                    })
                    .ToListAsync();
                response.Data = data;
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
                            CreatedAt = DateTime.UtcNow
                        };
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
                            CreatedAt = DateTime.UtcNow
                        };
                        await _notificationRepository.AddAsync(notification);
                        await _notificationRepository.SaveChangesAsync();
                    }

                    _tournamentTeamRequestRepository.Update(request);
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

                    await _tournamentTeamRequestRepository.AddAsync(request);
                    await _tournamentTeamRequestRepository.SaveChangesAsync();

                    // Gửi thông báo đến Partner
                    var notification = new Notification
                    {
                        UserId = dto.RecevierId,
                        Message = $"You have received a tournament invitation from {dto.RequesterId}.",
                        CreatedAt = DateTime.UtcNow,
                        IsRead = false
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
