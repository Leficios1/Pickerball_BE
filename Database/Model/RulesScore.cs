using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Database.Model
{
    public class RulesScore
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int Id { get; set; }
        public int MinDifference {  get; set; }
        public int MaxDifference { get; set; }
        public int WinnerGain { get; set; }
        public int LoseGain { get; set; }
        public DateTime CreateAt {  get; set; }
        public DateTime UpdateAt { get; set; }
    }
}
