using Database.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Database.DTO.Request
{
    public class TournamentRequestDTO
    {
        public int? Id { get; set; }
        public string Name { get; set; }
        public string Location { get; set; }
        public int MaxPlayer { get; set; }
        public string Description { get; set; }
        public string Banner { get; set; }
        public string Note { get; set; }
        public decimal TotalPrize { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
        public TournamentType Type { get; set; } // Singles, Doubles, Mixed
        public int OrganizerId { get; set; }
    }
    
    public class TournamenUpdatetRequestDTO
    {
        public int? Id { get; set; }
        public string? Name { get; set; }
        public string? Location { get; set; }
        public int? MaxPlayer { get; set; }
        public string? Description { get; set; }
        public string? Banner { get; set; }
        public string? Note { get; set; }
        public decimal? TotalPrize { get; set; }
        public DateTime? StartDate { get; set; }
        public DateTime? EndDate { get; set; }
        public TournamentType? Type { get; set; } // Singles, Doubles, Mixed
    }
}
