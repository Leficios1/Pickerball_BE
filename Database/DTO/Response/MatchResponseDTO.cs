using Database.Model;
using System;

namespace Database.DTO.Response
{
    public class MatchResponseDTO
    {
        public int Id { get; set; }
        public string Title { get; set; }
        public string Description { get; set; }
        public DateTime MatchDate { get; set; }
        public DateTime? CreateAt { get; set; }
        public int? VenueId { get; set; }
        public MatchStatus Status { get; set; } // Scheduled, Ongoing, Completed, Disable
        public MatchCategory MatchCategory { get; set; } // Competitive, Custom, Tournament
        public MatchFormat MatchFormat { get; set; } // Single, Team(Double)
        public WinScore WinScore { get; set; } // 11, 15, 21
        public int? Team1Score { get; set; }
        public int? Team2Score { get; set; }
        public bool IsPublic { get; set; }
        public int? RefereeId { get; set; } // Nếu có trọng tài
    }
}
