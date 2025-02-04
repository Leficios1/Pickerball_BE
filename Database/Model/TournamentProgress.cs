using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Database.Model
{
    public class TournamentProgress
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int Id { get; set; }

        [ForeignKey("TournamentRegistration")]
        public int TournamentRegistrationId { get; set; }
        public TournamentRegistration TournamentRegistration { get; set; }

        public int RoundNumber { get; set; }
        public bool IsEliminated { get; set; } = false; // True nếu đã bị loại
        public int Wins { get; set; } = 0;
        public int Losses { get; set; } = 0;

        public DateTime LastUpdated { get; set; } = DateTime.UtcNow;
    }
}
