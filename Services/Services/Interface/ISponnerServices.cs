using Database.DTO.Request;
using Database.DTO.Response;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Services.Services.Interface
{
    public interface ISponnerServices
    {
        Task<StatusResponse<SponnerResponseDTO>> getSponnerById(int SponnerId);
        Task<StatusResponse<List<SponnerResponseDTO>>> getAllSponner();
        Task<StatusResponse<SponnerResponseDTO>> CreateSponner(SponnerRequestDTO dto);
        Task<StatusResponse<SponnerResponseDTO>> UpdateSponner(SponnerRequestDTO dto);
        Task<StatusResponse<bool>> AccpetSponner(int SponnerId, bool isAccept);
    }
}
