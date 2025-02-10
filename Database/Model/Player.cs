using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Database.Model
{
    public class Player
    {
        [Key]
        [ForeignKey("User")]
        public int PlayerId { get; set; }
        public User User { get; set; }
        public string Province {  get; set; }
        public string City {  get; set; }
        public int TotalMatch { get; set; } = 0;
        public int TotalWins { get; set; } = 0;
        public int RankingPoint { get; set; } = 0;
        public int ExperienceLevel { get; set; } = 1;
        public DateTime JoinedAt { get; set; } = DateTime.UtcNow;

        public ICollection<TournamentRegistration> TournamentRegistrations { get; set; }
        public ICollection<Ranking> Rankings { get; set; } = new List<Ranking>();
        public ICollection<MatchesSendRequest> SentRequests { get; set; } = new List<MatchesSendRequest>();
        public ICollection<MatchesSendRequest> ReceivedRequests { get; set; } = new List<MatchesSendRequest>();
    }
}
