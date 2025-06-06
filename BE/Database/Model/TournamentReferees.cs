using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Database.Model
{
    public class TournamentReferees
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int Id { get; set; }

        [ForeignKey("Tournament")]
        public int TournamentId { get; set; }
        public Tournaments Tournament { get; set; }

        [ForeignKey("Referee")]
        public int RefereeId { get; set; }
        public Refree Referee { get; set; } // 🔥 Giả định rằng trọng tài là `User`

        public DateTime AssignedDate { get; set; } // Ngày được phân công
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
        public bool IsDone { get; set; } // Đã hoàn thành công việc
    }
}
