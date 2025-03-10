using Database.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Database.DTO.Response
{
    public class TouramentRegistraionResponseDTO
    {
        public int Id { get; set; }
        public int PlayerId { get; set; }
        public int TournamentId { get; set; }
        public DateTime RegisteredAt { get; set; }
        public TouramentregistrationStatus IsApproved { get; set; }
        public int? PartnerId { get; set; }
    }
}
