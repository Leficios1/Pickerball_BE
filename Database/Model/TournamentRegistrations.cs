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

        [ForeignKey("Payment")]
        public int PaymentId {  get; set; }
        public Payments Payment { get; set; }

        public DateTime RegisteredAt { get; set; }
        public bool IsApproved { get; set; } = false;

        //Fk
        
    }
}
