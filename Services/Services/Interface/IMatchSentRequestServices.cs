using Database.DTO.Request;
using Database.DTO.Response;
using Database.Model;
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
        Task<StatusResponse<MatchSentRequestResponseDTO>> SentRequest(MatchSentRequestRequestDTO dto);
        Task<StatusResponse<List<MatchSentRequestResponseDTO>>> GetByUserSendRequestId(int UserSendRequestId);
        Task<StatusResponse<List<MatchSentRequestResponseDTO>>> GetResponseByUserAcceptId(int UserAcceptId);
        Task<StatusResponse<List<MatchSentRequestResponseDTO>>> getAll();
        Task<StatusResponse<MatchSentRequestResponseDTO>> AcceptRequest(int RequestId, int UserAcceptId, SendRequestStatus Accpet);
        Task<StatusResponse<MatchSentRequestResponseDTO>> getById(int Id);
    }
}
