using Database.DTO.Response;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Database.DTO.Request
{
    public class UserUpdateRequestDTO
    {
        public int UserId { get; set; }
        public string? FirstName { get; set; } = null!;
        public string? LastName { get; set; } = null!;
        public string? SecondName { get; set; }
        //public string Email { get; set; } = null!;
        //public string? PasswordHash { get; set; }
        public DateTime? DateOfBirth { get; set; }
        public string? Gender { get; set; } = null!;
        public string? AvatarUrl { get; set; }
        public string? Status { get; set; }
    }
}
