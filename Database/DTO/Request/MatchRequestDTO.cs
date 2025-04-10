using Database.Model;

namespace Database.DTO.Request
{
    public class MatchRequestDTO
    {
        public string Title { get; set; }
        public string Description { get; set; }
        public DateTime MatchDate { get; set; }
        public int? VenueId { get; set; }
        public MatchStatus Status { get; set; } // Scheduled, Ongoing, Completed, Disable
        public MatchCategory MatchCategory { get; set; } // Competitive, Custom, Tournament
        public MatchFormat MatchFormat { get; set; } // Single, Team(Double)
        public WinScore WinScore { get; set; } // 11, 15, 21

        public bool IsPublic { get; set; }
        public int? RefereeId { get; set; } // Nếu có trọng tài
        public int RoomOnwerId { get; set; }
        public int? TouramentId { get; set; }
    }
    
    public class MatchUpdateRequestDTO
    {
        public string? Title { get; set; }
        public string? Description { get; set; }
        public DateTime? MatchDate { get; set; }
        public int? VenueId { get; set; }
        public MatchStatus? Status { get; set; } // Scheduled, Ongoing, Completed, Disable
        public MatchCategory? MatchCategory { get; set; } // Competitive, Custom, Tournament
        public MatchFormat? MatchFormat { get; set; } // Single, Team(Double)
        public WinScore? WinScore { get; set; } // 11, 15, 21

        public bool? IsPublic { get; set; }
        public int? RefereeId { get; set; } // Nếu có trọng tài
        public int? TouramentId { get; set; }
    }    
    public class MatchUpdateRequestForNormalMatchRequestDTO
    {
        public string? Title { get; set; }
        public string? Description { get; set; }
        public DateTime? MatchDate { get; set; }
        public int? VenueId { get; set; }
        public MatchStatus? Status { get; set; } // Scheduled, Ongoing, Completed, Disable
        public MatchCategory? MatchCategory { get; set; } // Competitive, Custom, Tournament
        public MatchFormat? MatchFormat { get; set; } // Single, Team(Double)
        public WinScore? WinScore { get; set; } // 11, 15, 21

        public bool? IsPublic { get; set; }
        public int? RefereeId { get; set; } // Nếu có trọng tài
    }
}
