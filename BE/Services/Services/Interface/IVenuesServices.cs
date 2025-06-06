using Database.DTO.Request;
using Database.DTO.Response;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Services.Services.Interface
{
    public interface IVenuesServices
    {
        Task<StatusResponse<VenuesResponseDTO>> GetVenuesAsync(int id);
        Task<StatusResponse<List<VenuesResponseDTO>>> GetAllVenuesAsync();
        Task<StatusResponse<VenuesResponseDTO>> CreateVenuesAsync(VenuesRequestDTO dto);
        Task<StatusResponse<List<VenuesResponseDTO>>> GetVenuesSponner(int id);
        Task<StatusResponse<VenuesResponseDTO>> UpdateVenuesAsync(int id, VenuesRequestDTO dto);
    }
}
