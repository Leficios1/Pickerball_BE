using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Database.DTO.Request
{
    public class UserRegisterRequestDTO
    {
        public string FirstName { get; set; } = null!;
        public string LastName { get; set; } = null!;
        public string? SecondName { get; set; }
        public string Email { get; set; } = null!;
        public string PasswordHash { get; set; } = null!; //password
        public DateTime? DateOfBirth { get; set; }

        [MaxLength(10)]
        public string? Gender { get; set; }
    }
    public class PlayerDetailsRequest
    {
        public int PlayerId { get; set; }
        public string Province { get; set; }
        public string City { get; set; }
        //public int TotalMatch { get; set; } = 0;
        //public int TotalWins { get; set; } = 0;
        //public int RankingPoint { get; set; } = 0;
        //public int ExperienceLevel { get; set; } = 1;
        //public DateTime JoinedAt { get; set; } = DateTime.UtcNow;
    }
    public class SponsorDetailsRequest
    {
        public int SponsorId { get; set; }
        public string CompanyName { get; set; } = null!;
        public string? LogoUrl { get; set; }
        public string ContactEmail { get; set; } = null!;
        public string? Descreption { get; set; }
        //public bool isAccept { get; set; }
        //public DateTime JoinedAt { get; set; } = DateTime.UtcNow;
    }
}
