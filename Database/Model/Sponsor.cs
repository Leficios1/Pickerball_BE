using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Database.Model
{
    public class Sponsor
    {
        [Key]
        [ForeignKey("User")]
        public int SponsorId { get; set; }
        public User User { get; set; }
        public string CompanyName { get; set; } = null!;
        public string? LogoUrl { get; set; }
        public string ContactEmail { get; set; } = null!;
        public string? Descreption { get; set; }
        public bool isAccept {  get; set; }
        public DateTime JoinedAt { get; set; } = DateTime.UtcNow;

        //Fk
        public ICollection<Payments> Payments { get; set; } // Thanh toán tài trợ

    }
}
