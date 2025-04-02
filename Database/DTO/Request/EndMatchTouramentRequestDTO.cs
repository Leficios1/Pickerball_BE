using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Database.DTO.Request
{
    public class EndMatchTouramentRequestDTO
    {
        public int MatchId { get; set; }
        public int Round { get; set; }
        public string? Note { get; set; }
        public int? CurrentHaft { get; set; }
        public int Team1Score { get; set; }
        public int Team2Score { get; set; }
        public string? Log { get; set; }
    }
}
