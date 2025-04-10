using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Database.DTO.Request
{
    public class MatchRequest
    {
        public int UserId { get; set; }
        public string Gender { get; set; }
        public int Ranking { get; set; }
        public int Level { get; set; }
        public int MatchCategory { get; set; }
        public int MatchFormat { get; set; }
        public string City { get; set; }
        public string ConnectionId { get; set; }
    }
}
