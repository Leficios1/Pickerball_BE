using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Database.DTO.Response
{
    public class TournamentResponseDTO
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string Location { get; set; }
        public int MaxPlayer { get; set; }
        public string Description { get; set; }
        public string Banner { get; set; }
        public string Note { get; set; }
        public decimal TotalPrize { get; set; }
        public string Status { get; set; } // Pending, Complete, Reject
        public bool IsAccept { get; set; } // False if chưa accept
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
        public string Type { get; set; }
        public int OrganizerId { get; set; }
        public List<MatcheDetails>? TouramentDetails { get; set; }
        public List<RegistrationDetails>? RegistrationDetails { get; set; }

    }
    public class MatcheDetails
    {
        public int Id { get; set; }
        public int PlayerId1 { get; set; }
        public int PlayerId2 { get; set; }
        public int? PlayerId3 { get; set; }
        public int? PlayerId4 { get; set; }
        public DateTime ScheduledTime { get; set; }
        public string Score { get; set; }
        public string Result { get; set; }

    }
    public class RegistrationDetails
    {
        public int Id { get; set; }
        public int PlayerId { get; set; }
        public int PaymentId { get; set; }
        public DateTime RegisteredAt { get; set; }
        public bool isApproved { get; set; }
        public PlayerRegistrationDetails PlayerDetails { get; set; }
    }
    public class PlayerRegistrationDetails
    {
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string? SecondName { get; set; }
        public string Email { get; set; }
        public int Ranking { get; set; }
        [Url]
        public string AvatarUrl { get; set; }
    }
}
