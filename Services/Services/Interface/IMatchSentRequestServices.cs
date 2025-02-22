using Database.DTO.Response;
using Repository.Repository.Interfeace;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Services.Services.Interface
{
    public interface IMatchSentRequestServices
    {
        Task<StatusResponse<MatchSentRequestResponseDTO>> SentRequest(MatchSentRequestResponseDTO dto);
        Task<StatusResponse<MatchSentRequestResponseDTO>> GetRequestById(int id);
        Task<StatusResponse<MatchSentRequestResponseDTO>> AcceptRequest(int SentRequestId, int PlayerAcceptId);
    }
}
