using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Database.Model
{
    public class Refree
    {
        [Key]
        [ForeignKey("User")]
        public int RefreeId { get; set; }
        public User User { get; set; }
        public string? RefreeCode { get; set; }
        public string? RefreeLevel { get; set; }
        public string? RefreeNote { get; set; }
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
        public DateTime LastUpdatedAt { get; set; } = DateTime.UtcNow;
        public bool isAccept { get; set; }
        public ICollection<TournamentReferees> TournamentReferees { get; set; } // 🔥 Giải đấu mà user làm trọng tài

    }
}
