using System;
using System.Collections.Generic;
using Database.Model;

namespace Database.DTO.Response
{
    public class RoomResponseDTO
    {
        public int Id { get; set; }
        public string Title { get; set; }
        public string Description { get; set; }
        public DateTime MatchDate { get; set; }
        public int? VenueId { get; set; }
        public MatchStatus Status { get; set; }
        public MatchCategory MatchCategory { get; set; }
        public MatchFormat MatchFormat { get; set; }
        public WinScore WinScore { get; set; }
        public int? RoomOwner { get; set; }
        public int? Team1Score { get; set; }
        public int? Team2Score { get; set; }
        public bool IsPublic { get; set; }
        public int? RefereeId { get; set; }
        public List<TeamResponseDTO> Teams { get; set; }
    }
}
