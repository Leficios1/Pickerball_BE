using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Database.Model
{
    public class TournamentTeamRequest
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int Id { get; set; }

        [ForeignKey("TournamentRegistration")]
        public int RegistrationId { get; set; }
        public TournamentRegistration TournamentRegistration { get; set; }

        [ForeignKey("Requester")]
        public int RequesterId { get; set; }
        public Player Requester { get; set; }  // Người gửi lời mời

        [ForeignKey("Partner")]
        public int PartnerId { get; set; }
        public Player Partner { get; set; }    // Người nhận lời mời

        public TournamentRequestStatus Status { get; set; } // Pending, Accepted, Rejected
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    }
    public enum TournamentRequestStatus
    {
        Pending = 1,
        Accepted = 2,
        Rejected = 3
    }
}
