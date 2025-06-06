using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Database.Model
{
    public class TeamMembers
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int Id { get; set; }

        public int TeamId { get; set; }
        public Team Team { get; set; }

        [ForeignKey("Playermember")]
        public int PlayerId { get; set; }
        public Player Playermember { get; set; }

        public DateTime JoinedAt { get; set; }

    }
}
