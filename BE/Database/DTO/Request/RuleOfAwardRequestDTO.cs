using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Database.DTO.Request
{
    public class RuleOfAwardRequestDTO
    {
        public int Id { get; set; }
        public int Position { get; set; }
        public int PercentOfPrize { get; set; }
    }
}
