using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Database.Model
{
    public class Friends
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int Id { get; set; }

        [ForeignKey("User1")]
        public int User1Id { get; set; } // Người gửi lời mời kết bạn
        public User User1 { get; set; }

        [ForeignKey("User2")]
        public int User2Id { get; set; } // Người nhận lời mời kết bạn
        public User User2 { get; set; }

        public FriendStatus Status { get; set; } = FriendStatus.Pending; // Trạng thái quan hệ bạn bè
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    }
    public enum FriendStatus
    {
        Pending, 
        Accepted,  
        Blocked  
    }
}
