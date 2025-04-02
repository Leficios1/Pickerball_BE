using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Database.DTO.Response
{
    public class UserResponseDTO
    {
        public int Id { get; set; }
        public string FirstName { get; set; } = null!;
        public string LastName { get; set; } = null!;
        public string? SecondName { get; set; }
        public string Email { get; set; } = null!;
        //public string PasswordHash { get; set; } = null!; // Hash password
        public DateTime? DateOfBirth { get; set; }

        [Url]
        public string? AvatarUrl { get; set; }
        public string PhoneNumber { get; set; }

        [MaxLength(10)]
        public string? Gender { get; set; }
        public bool Status { get; set; }
        public int RoleId { get; set; } // Admin, Organizer, Player, Spectator
        public string RefreshToken { get; set; } = null!;
        public DateTime? CreateAt { get; set; }
        public DateTime RefreshTokenExpiryTime { get; set; }
        public PlayerDetails? userDetails { get; set; }
        public SponsorDetails? sponsorDetails { get; set; }
    }
    public class PlayerDetails
    {
        public string Province { get; set; }
        public string City { get; set; }
        public string? CCCD { get; set; }
        //public int TotalMatch { get; set; } = 0;
        //public int TotalWins { get; set; } = 0;
        //public int RankingPoint { get; set; } = 0;
        //public int ExperienceLevel { get; set; } = 1;
        public DateTime JoinedAt { get; set; } = DateTime.UtcNow;
    }
    public class SponsorDetails
    {
        public string CompanyName { get; set; } = null!;
        public string? LogoUrl { get; set; }
        public string ContactEmail { get; set; } = null!;
        public string? Descreption { get; set; }
        //public bool isAccept { get; set; }
        public DateTime JoinedAt { get; set; } = DateTime.UtcNow;
    }
}
