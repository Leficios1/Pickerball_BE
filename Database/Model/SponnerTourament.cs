using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Database.Model
{
    public class SponnerTourament
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int Id { get; set; }

        [ForeignKey("Tournament")]
        public int TournamentId { get; set; }
        public Tournaments Tournament { get; set; }

        [ForeignKey("Sponsor")]
        public int SponsorId { get; set; }
        public Sponsor Sponsor { get; set; }

        public decimal? SponsorAmount { get; set; } // Số tiền tài trợ
        public string? SponsorNote { get; set; } // Ghi chú tài trợ
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    }
}
