using Database.DTO.Request;
using Database.DTO.Response;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Services.Services.Interface
{
    public interface ITouramentRegistrationServices
    {
        Task<StatusResponse<TouramentRegistraionResponseDTO>> CreateRegistration(TouramentRegistrationDTO dto);
        Task<StatusResponse<TouramentRegistraionResponseDTO>> AcceptPlayer(int PlayerId, bool isAccept, int touramentId);
        Task<StatusResponse<List<TouramentRegistraionResponseDTO>>> GetAll();
        Task<StatusResponse<TouramentRegistraionResponseDTO>> GetById(int id);
        Task<StatusResponse<List<TouramentRegistraionResponseDTO>>> GetByTouramentId(int TourId);
    }
}
