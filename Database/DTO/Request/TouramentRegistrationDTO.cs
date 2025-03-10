using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Database.DTO.Request
{
    public class TouramentRegistrationDTO
    {
        public int TournamentId { get; set; }
        public int PlayerId { get; set; }
        public bool isAccept { get; set; } = false;
        public int? PartnerId { get; set; }
    }
}
