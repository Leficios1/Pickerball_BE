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
        [Url]
        public string UrlSocial { get; set; } = null!;
        [Url]
        public string? UrlSocial1 { get; set; } = null!;
        public string ContactEmail { get; set; } = null!;
        public string? Descreption { get; set; }
        public bool isAccept {  get; set; }
        public DateTime JoinedAt { get; set; } = DateTime.UtcNow;

        //Fk
        

    }
}
