using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Database.DTO.Request
{
    public class SponnerTouramentRequestDTO
    {
        public int SponnerId { get; set; }
        public int TouramentId { get; set; }
        public int ReturnUrl { get; set; }
        public int Amount { get; set; }
    }
}
