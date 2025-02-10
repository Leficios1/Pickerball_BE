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
    }
}
