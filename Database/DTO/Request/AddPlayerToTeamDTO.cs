using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Database.DTO.Request
{
    public class AddPlayerToTeamDTO
    {
        public int TeamId { get; set; }
        public int PlayerId { get; set; }
    }
    
    public class DeletePlayerToTeamDTO : AddPlayerToTeamDTO
    {

    }
}
