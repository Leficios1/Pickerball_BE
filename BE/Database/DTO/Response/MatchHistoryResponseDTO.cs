using Database.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Database.DTO.Response
{
    public class MatchHistoryResponseDTO
    {
        public int MatchId {  get; set; }
        public string MatchName { get; set; } = string.Empty;
        public MatchCategory MatchCategory { get; set; }
        public int Team1Score {  get; set; }
        public int Team2Score { get; set; }
    }
}
