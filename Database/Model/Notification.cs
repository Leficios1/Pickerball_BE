using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Database.Model
{
    public class Notification
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int Id { get; set; }
        public int UserId { get; set; }
        public User User { get; set; }

        public string Message { get; set; }
        public DateTime CreatedAt { get; set; }
        public bool IsRead { get; set; }
        public NotificationType? Type { get; set; } // Type of notification
        public int? ReferenceId { get; set; } // Id tham chiếu đến bảng tương ứng

    }
    public enum NotificationType
    {
        FriendRequest = 1,
        MatchRequest = 2,
        TournamentTeamRequest = 3,
        Other = 4
    }

}
