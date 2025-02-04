using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Database.Model
{
    public class Room
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int Id { get; set; }

        [ForeignKey("Creator")]
        public int CreatorId { get; set; } // Người tạo phòng
        public Player Creator { get; set; }

        public string RoomName { get; set; }
        public string? Location {  get; set; }
        public RoomType Type { get; set; } // 1vs1, 2vs2
        public DateTime ScheduledAt {  get; set; }
        public string? Descreption {  get; set; }
        public string? Note {  get; set; }
        public RoomStatus Status { get; set; } // Waiting, Ongoing, Finished

        public bool IsPublic { get; set; } // True nếu là phòng công khai
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;

        // Lưu kết quả trận đấu
        public int? WinningTeamId { get; set; } // Team thắng (null nếu chưa có)
        public int? LosingTeamId { get; set; } // Team thua (null nếu chưa có)
        public bool? IsDraw { get; set; } // True nếu hòa
    }
    public enum RoomType
    {
        OneVsOne,
        TwoVsTwo
    }

    public enum RoomStatus
    {
        Waiting,  // Đang chờ người tham gia
        Ongoing,  // Đang diễn ra
        Finished  // Kết thúc
    }
}
