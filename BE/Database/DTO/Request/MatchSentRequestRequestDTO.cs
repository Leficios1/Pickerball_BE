using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Database.DTO.Request
{
    public class MatchSentRequestRequestDTO
    {
        public int? Id { get; set; }
        public int MatchingId { get; set; }
        public int PlayerRequestId { get; set; }
        public int PlayerRecieveId { get; set; }
    }
}
