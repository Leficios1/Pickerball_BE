using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Database.DTO.Request
{
    public class RankingRequestDTO
    {
        public int UserId { get; set; }
        public int TouramentId { get; set; }
        public int Position { get; set; }
        public decimal Award {  get; set; }
        public int PercentOfPrize { get; set; }
    }
}
