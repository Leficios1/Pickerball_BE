using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Database.Model.Dbcontext;

namespace Database.Model
{
    public class Matches
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int Id { get; set; }

        public string Title { get; set; }
        public string Description { get; set; }
        public DateTime MatchDate { get; set; }
        public DateTime? CreateAt { get; set; } = DateTime.Now;

        [ForeignKey("Venue")] public int? VenueId { get; set; }
        public Venues? Venue { get; set; }
        public MatchStatus Status { get; set; } // Scheduled, Ongoing, Completed, Disable
        public MatchCategory MatchCategory { get; set; } // Competitive, Custom, Tournament
        public MatchFormat MatchFormat { get; set; } // Single, Team(Double)
        public WinScore WinScore { get; set; } // 11, 15, 21
        public int? Team1Score { get; set; }
        public int? Team2Score { get; set; }
        public bool IsPublic { get; set; }

        [ForeignKey("Referee")] public int? RefereeId { get; set; } // Nếu có trọng tài
        public User? Referee { get; set; }

        // Navigation properties
        public ICollection<TouramentMatches> TournamentMatches { get; set; } = new List<TouramentMatches>();
        public ICollection<MatchesSendRequest> MatchRequests { get; set; } = new List<MatchesSendRequest>();
    }

    public enum WinScore
    {
        Eleven = 1,
        Fifteen = 2,
        Twentyone = 3
    }

    public enum MatchStatus
    {
        Scheduled = 1,
        Ongoing = 2,
        Completed = 3,
        Disable = 4
    }

    public enum MatchCategory
    {
        Competitive = 1,
        Custom = 2,
        Tournament = 3
    }

    public enum MatchFormat
    {
        Single = 1,
        Team = 2
    }
}
