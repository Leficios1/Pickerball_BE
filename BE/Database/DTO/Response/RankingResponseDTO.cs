using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Database.DTO.Response
{
    public class RankingResponseDTO
    {
        public int UserId { get; set; }
        public string? FullName { get; set; }
        public string? Avatar { get; set; }
        public int? RankingPoint { get; set; }
        public int? ExeprienceLevel { get; set; }
        public int? TotalMatch { get; set; }
        public int? TotalWins { get; set; }
        public int? Point {  get; set; }
        public int? Position { get; set; }
        public int? PercentOfPrize { get; set; }
        public int? Prize { get; set; }
    }
}
