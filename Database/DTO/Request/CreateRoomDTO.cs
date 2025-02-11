using Database.Model;

namespace Database.DTO.Request
{
    public class CreateRoomDTO
    {
        // Thông tin trận đấu
        public string Title { get; set; }
        public string Description { get; set; }
        public DateTime MatchDate { get; set; }
        public MatchStatus Status { get; set; } // Scheduled, Ongoing, Completed, Disable
        public MatchCategory MatchCategory { get; set; } // Competitive, Custom, Tournament
        public MatchFormat MatchFormat { get; set; } // Single, Team(Double)
        public bool IsPublic { get; set; }
        public int? RefereeId { get; set; } // Nếu có trọng tài

        // Thông tin sân
        public int? VenueId { get; set; }

        // Thông tin đội
        public int? Player1Id { get; set; }
        public int? Player2Id { get; set; }
        public int? Player3Id { get; set; }
        public int? Player4Id { get; set; }
    }
}