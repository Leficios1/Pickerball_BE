using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Database.Model
{
    public class MatchesSendRequest
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int Id { get; set; }

        [ForeignKey("Matches")]
        public int MatchingId {get; set; }
        public Matches Matches { get; set; }

        [ForeignKey("PlayerRequest")]
        public int PlayerRequestId { get; set; }
        public Player PlayerRequest { get; set; }

        [ForeignKey("PlayerReceive")]
        public int PlayerRecieveId { get; set; }
        public Player PlayerReceive { get; set; }


        public SendRequestStatus status {  get; set; } 
        public DateTime CreateAt { get; set; }
        public DateTime LastUpdatedAt { get; set; }
        
    }
    public enum SendRequestStatus
    {
        Accept,
        Reject,
        Pending
    }
}
