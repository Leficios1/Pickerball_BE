using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Database.Model
{
    public class Ranking
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int Id { get; set; }

        [ForeignKey("Player")]
        public int PlayerId { get; set; } 
        public Player Player { get; set; }

        public int TournamentId { get; set; }
        public Tournaments Tournament { get; set; }

        public int Points { get; set; }
        public int Position { get; set; }


    }
}
