using Database.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Repository.Repository.Interfeace
{
    public interface IMatchSentRequestRepository : IBaseRepository<MatchesSendRequest>
    {
        Task<List<MatchesSendRequest>> GetByReceviedId(int ReceviedId);
        Task<List<MatchesSendRequest>> GetByRequestId(int RequestId);
    }
}
