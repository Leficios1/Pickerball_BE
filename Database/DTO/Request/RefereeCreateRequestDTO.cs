using System.Text.Json.Serialization;

namespace Database.DTO.Request
{
    public class RefereeCreateRequestDTO
    {
        private bool _status = true;
        private int _roleId = 4;
        public string FirstName { get; set; } = null!;
        public string LastName { get; set; } = null!;
        public string? SecondName { get; set; }
        public string Email { get; set; } = null!;
        public string Password { get; set; } = null!;
        public DateTime? DateOfBirth { get; set; }
        public string? AvatarUrl { get; set; } = "https://inkythuatso.com/uploads/thumbnails/800/2023/03/9-anh-dai-dien-trang-inkythuatso-03-15-27-03.jpg";
        public string? Gender { get; set; }
        [JsonIgnore]
        public bool Status
        {
            get => _status;
        }
        [JsonIgnore]
        public int RoleId { get => _roleId; }
        [JsonIgnore]
        public DateTime? CreateAt { get => DateTime.UtcNow; }
    }
}
