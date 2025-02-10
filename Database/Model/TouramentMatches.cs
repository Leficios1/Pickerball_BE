using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Database.Model
{
    public class TouramentMatches
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int Id { get; set; }

        // Foreign Key liên kết với Tournament
        public int TournamentId { get; set; }
        public Tournaments Tournament { get; set; }
        public int MatchesId { get; set; }
        public Matches Matches { get; set; }
        public DateTime CreateAt { get; set; }
    }
}
