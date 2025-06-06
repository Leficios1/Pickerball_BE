using Database.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Database.DTO.Response
{
    public class MatchSentRequestResponseDTO
    {
        public int Id { get; set; }
        public int MatchingId { get; set; }
        public int PlayerRequestId { get; set; }
        public int PlayerRecieveId { get; set; }
        public SendRequestStatus status { get; set; }
        public DateTime CreateAt { get; set; }
        public DateTime LastUpdatedAt { get; set; }

    }
}
