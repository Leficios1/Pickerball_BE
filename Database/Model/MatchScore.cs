using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Database.Model
{
    public class MatchScore
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int MatchScoreId { get; set; }

        [ForeignKey("Match")]
        public int MatchId { get; set; }
        public Matches Match { get; set; }
        public int? Round { get; set; }
        public string? Note { get; set; }
        public int? CurrentHaft { get; set; }// Trận thứ mấy ở BO3

        public int Team1Score { get; set; }

        public int Team2Score { get; set; }
    }
}
