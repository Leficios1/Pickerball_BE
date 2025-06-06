using Database.Model;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Database.DTO.Response
{
    public class EndMatchResponseDTO
    {
        public int MatchId { get; set; }
        public int Team1Score { get; set; }
        public int Team2Score { get; set; }
        public int? WinnerId { get; set; }
        public int? LoserId { get; set; }
        public DateTime Date { get; set; }
        public string? UrlVideoMatch { get; set; }

        public string? Log { get; set; }
        public List<MatchScoreResponseDTO>? matchScoreDetails { get; set; }
    }
    public class MatchScoreResponseDTO
    {
        public int MatchScoreId { get; set; }
        public int? Round { get; set; }
        public string? Note { get; set; }
        public int? CurrentHaft { get; set; }// Trận thứ mấy ở BO3
        public int Team1Score { get; set; }
        public int Team2Score { get; set; }
    }
}
