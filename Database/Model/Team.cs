using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Database.Model
{
    public class Team
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int Id { get; set; }
        public string Name { get; set; }

        [ForeignKey("Captain")]
        public int? CaptainId { get; set; } // Người tạo team
        public TournamentRegistration Captain { get; set; }

        [ForeignKey("Matches")]
        public int MatchingId { get; set; }
        public Matches Matches { get; set; }

        public ICollection<TeamMembers> Members { get; set; }
    }

}
