using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Database.DTO.Request
{
    public class EndMatchNormalRequestDTO
    {
        public int MatchId { get; set; }
        public int Team1Score { get; set; }
        public int Team2Score { get; set; }
        public string? UrlMatch { get; set; }
        public string? Log { get; set; }
    }
}
