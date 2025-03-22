using Database.DTO.Request;
using Database.DTO.Response;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Services.Services.Interface
{
    public interface IPlayerServices
    {
        Task<StatusResponse<PlayerDetails>> CreatePlayer(PlayerDetailsRequest player);
        Task<StatusResponse<PlayerDetails>> GetPlayerById(int PlayerId);
        Task<StatusResponse<List<PlayerDetails>>> GetAllPlayers();
        Task<StatusResponse<PlayerDetails>> UpdatePlayer(PlayerDetailsRequest player);
        Task<StatusResponse<List<PlayerResponseDTO>>> PagingPlayers(int? PageNumber, int? Pagesize, bool isOrderbyCreateAt);
    }
}
