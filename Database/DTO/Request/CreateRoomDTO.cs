using Database.Model;

namespace Database.DTO.Request
{
    public class CreateRoomDTO
    {
        // Match information
        public string Title { get; set; }
        public string Description { get; set; }
        public DateTime MatchDate { get; set; }
        public MatchStatus Status { get; set; } // Scheduled, Ongoing, Completed, Disable
        public MatchCategory MatchCategory { get; set; } // Competitive, Custom, Tournament
        public MatchFormat MatchFormat { get; set; } // Single, Team(Double)
        public bool IsPublic { get; set; }
        public WinScore WinScore { get; set; } // 11, 15, 21
        public int? RefereeId { get; set; } // If there is a referee

        // Venue information
        public int? VenueId { get; set; }

        // Team information
        public int? Player1Id { get; set; }
        public int? Player2Id { get; set; }
        public int? Player3Id { get; set; }
        public int? Player4Id { get; set; }
    }
}
