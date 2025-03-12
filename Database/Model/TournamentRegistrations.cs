using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Database.Model
{
    public class TournamentRegistration
    {
        public int Id { get; set; }
        public int TournamentId { get; set; }
        public Tournaments Tournament { get; set; }

        [ForeignKey("Player")]
        public int PlayerId { get; set; }
        public Player Player { get; set; }
        [ForeignKey("Partner")]
        public int? PartnerId { get; set; }
        public Player? Partner { get; set; }
        public DateTime RegisteredAt { get; set; } = DateTime.UtcNow;
        public TouramentregistrationStatus IsApproved { get; set; }
        public string? Reason { get; set; }

        //Fk

    }
    public enum TouramentregistrationStatus
    {
        Pending = 1,// Da accept tu partner cho payment
        Approved = 2,// Da payment
        Rejected = 3, // Ko dong y cho tham gia giai dau
        Waiting = 4, // Cho accept tu partner
        Eliminated = 5 // Bi loai
    }
}
