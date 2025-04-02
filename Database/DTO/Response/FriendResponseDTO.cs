using Database.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Database.DTO.Response
{
    public class FriendResponseDTO
    {
        public int Id { get; set; }
        public int User1Id { get; set; }
        public int User2Id { get; set; }
        public int? UserFriendId { get; set; }
        public string? UserFriendName { get; set; }
        public string? UserFriendAvatar { get; set; }
        public FriendStatus Status { get; set; }
        public DateTime CreatedAt { get; set; }
        public string? Gender { get; set; }
        public int? ExeprienceLevel { get; set; }
    }
}
