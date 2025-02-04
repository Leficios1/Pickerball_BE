using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Database.Model
{
    public class Matches
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int Id { get; set; }

        // Foreign Key liên kết với Tournament
        public int TournamentId { get; set; }
        public Tournaments Tournament { get; set; }

        [ForeignKey("Player1")]
        public int? Player1Id { get; set; }
        public Player? Player1 { get; set; }

        [ForeignKey("Player2")]
        public int? Player2Id { get; set; }
        public Player? Player2 { get; set; }

        // Doubles Mode
        [ForeignKey("Team1")]
        public int? Team1Id { get; set; }
        public Team? Team1 { get; set; }

        [ForeignKey("Team2")]
        public int? Team2Id { get; set; }
        public Team? Team2 { get; set; }

        public DateTime MatchDate { get; set; }

        [ForeignKey("Venue")]
        public int VenueId { get; set; }
        public Venues Venue { get; set; }
        public MatchStatus Status { get; set; } // Scheduled, Ongoing, Completed
        public int? Team1Score { get; set; }
        public int? Team2Score { get; set; }

        [ForeignKey("Referee")]
        public int? RefereeId { get; set; } // Nếu có trọng tài
        public User? Referee { get; set; }
    }

    public enum MatchStatus
    {
        Scheduled,
        Ongoing,
        Completed
    }
}
