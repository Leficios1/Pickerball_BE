using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Database.DTO.Request
{
    public class AcceptSponserRequestDTO
    {
        public int SponnerId { get; set; }
        public bool IsAccept { get; set; }
    }
}
