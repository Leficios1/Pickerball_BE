using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Data;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;

namespace Database.Model
{
    public class User
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int Id { get; set; }
        public string FirstName { get; set; } = null!;
        public string LastName { get; set; } = null!;
        public string? SecondName {  get; set; }
        public string Email { get; set; } = null!;
        public string PasswordHash { get; set; } = null!; // Hash password
        public DateTime? DateOfBirth { get; set; }

        [Url]
        public string? AvatarUrl { get; set; }

        [MaxLength(10)]
        public string? Gender { get; set; }
        public bool Status { get; set; }
        public int RoleId { get; set; } // Admin, Organizer, Player, Spectator
        public string RefreshToken { get; set; } = null!;
        public DateTime? CreateAt { get; set; }
        public DateTime RefreshTokenExpiryTime { get; set; }

        //Navigation
        public Role Role { get; set; }
        public Player Player { get; set; }
        public Sponsor Sponsor { get; set; }

        //public ICollection<TournamentRegistration> TournamentRegistrations { get; set; }
        //public ICollection<Payments> Payments { get; set; }
        //public ICollection<Matches> MatchesAsPlayer1 { get; set; }
        //public ICollection<Matches> MatchesAsPlayer2 { get; set; }
        //public ICollection<Ranking> Rankings { get; set; }
        public ICollection<Achievement> Achievements { get; set; }
        public ICollection<Notification> Notifications { get; set; }
        //public ICollection<TeamMembers> TeamMembers { get; set; } // Sửa lại đúng tên

    }
}
