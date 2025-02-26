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
        Task<StatusResponse<bool>> CreateRegistration(TouramentRegistrationDTO dto);
        Task<StatusResponse<bool>> AcceptPlayer(int PlayerId, bool isAccept);
    }
}
