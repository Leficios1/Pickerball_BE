using Database.DTO.Response;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Services.Services.Interface
{
    public interface IAchivementServices
    {
        public Task<StatusResponse<List<AchivementResponseDTO>>> GetAchivementByUserId(int userId);
    }
}
