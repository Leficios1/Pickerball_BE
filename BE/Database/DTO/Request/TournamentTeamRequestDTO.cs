using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Database.DTO.Request
{
    public class TournamentTeamRequestDTO
    {
        public int RegistrationId { get; set; }
        public int RequesterId { get; set; }
        public int RecevierId { get; set; }
    }
}
