using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;

namespace Database.Model
{
    public class Tournaments
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int Id { get; set; }
        public string Name { get; set; }
        public string Location { get; set; }
        public int MaxPlayer {  get; set; }
        public string? Descreption {  get; set; }
        public int? IsMinRanking { get; set; }
        public int? IsMaxRanking { get; set; }
        public string Banner {  get; set; }
        [Url]
        public string? Social { get; set; }
        public string? Note {  get; set; }
        public decimal TotalPrize {  get; set; }
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
        public DateTime CreateAt { get; set; }
        public TournamentType Type { get; set; } // Single, Doubles
        public string Status {  get; set; }
        public bool IsAccept { get; set; }
        public bool IsFree { get; set; }
        public decimal? EntryFee { get; set; }

        [ForeignKey("Organizer")]
        public int OrganizerId { get; set; }
        public User Organizer { get; set; }

        public ICollection<TournamentRegistration> Registrations { get; set; }
        //public ICollection<Matches> Matches { get; set; }
        public ICollection<Ranking> Rankings { get; set; }
        public ICollection<Payments> Payments { get; set; }
        public ICollection<SponnerTourament> Sponsors { get; set; }
        public ICollection<TournamentReferees> TournamentReferees { get; set; }


        //public ICollection<MatchTeam> MatchTeams { get; set; } // Đúng tên Property
        //public ICollection<TournamentVenues> TournamentVenues { get; set; }

    }

    public enum TournamentType
    {
        SinglesMale = 1,
        SinglesFemale = 2,
        DoublesMale = 3,
        DoublesFemale = 4,
        DoublesMix = 5
    }
}
