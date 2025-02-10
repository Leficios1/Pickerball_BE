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
        public int RoleId {  get; set; }
    }
}
