using Database.Model;
using Database.Model.Dbcontext;
using Microsoft.EntityFrameworkCore;
using Repository.Repository.Interfeace;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Repository.Repository
{
    public class MatchSentRequestRepository : BaseRepository<MatchesSendRequest>, IMatchSentRequestRepository
    {
        private readonly PickerBallDbcontext _context;
        public MatchSentRequestRepository(PickerBallDbcontext context) : base(context)
        {
            _context = context;
        }

        public async Task<List<MatchesSendRequest>> GetByReceviedId(int ReceviedId)
        {
            return await _context.MatchesSendRequest.Where(x => x.PlayerRecieveId == ReceviedId).ToListAsync();
        }

        public async Task<List<MatchesSendRequest>> GetByRequestId(int RequestId)
        {
            return await _context.MatchesSendRequest.Where(x => x.PlayerRequestId == RequestId).ToListAsync();
        }
    }
}
