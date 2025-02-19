using AutoMapper;
using Database.DTO.Request;
using Database.DTO.Response;
using Database.Model;
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
        private readonly IMapper _mapper;
        public TouramentRegistrationServices(ITournamentRegistrationRepository tournamentRegistrationRepository, IMapper mapper)
        {
            _tournamentRegistrationRepository = tournamentRegistrationRepository;
            _mapper = mapper;
        }

        public async Task<StatusResponse<bool>> CreateRegistration(TouramentRegistrationDTO dto)
        {
            var response = new StatusResponse<bool>();
            try
            {
                var data = new TournamentRegistration()
                {
                    PlayerId = dto.PlayerId,
                    TournamentId = dto.TournamentId,
                    RegisteredAt = DateTime.UtcNow,
                    IsApproved = false
                };
                await _tournamentRegistrationRepository.AddAsync(data);
                await _tournamentRegistrationRepository.SaveChangesAsync();
                response.Data = true;
                response.statusCode = HttpStatusCode.OK;
                response.Message = "Registration Created Successfully";
            }
            catch(Exception ex)
            {
                response.statusCode = HttpStatusCode.InternalServerError;
                response.Message = ex.Message;
            }
            return response;
        }
    }
}
