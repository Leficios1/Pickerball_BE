using Database.DTO.Request;
using Database.DTO.Response;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Services.Services.Interface
{
    public interface IRankingServices
    {
        Task<StatusResponse<List<RankingResponseDTO>>> LeaderBoard();
        Task<StatusResponse<List<RankingResponseDTO>>> LeaderBoardTourament(int tourId);
        Task<StatusResponse<bool>> AwardForPlayer(int tourId);
        Task<StatusResponse<List<RuleOfAwardResponseDTO>>> GetRuleOfAwardForPlayer();
        Task<StatusResponse<RuleOfAwardResponseDTO>> UpdateRuleOfAwardForPlayer(RuleOfAwardRequestDTO dto); 
    }
}
