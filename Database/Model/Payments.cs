using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Database.Model
{
    public class Payments
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int Id { get; set; }

        [ForeignKey("Sponsor")]
        public int UserId { get; set; }
        public User User { get; set; }

        [ForeignKey("Tournaments")]
        public int TournamentId { get; set; }
        public Tournaments Tournament { get; set; }

        public decimal Amount { get; set; }
        public PaymentStatus Status { get; set; } // Pending, Completed, Failed
        public TypePayment Type {  get; set; }
        public DateTime PaymentDate { get; set; }
    }

    public enum PaymentStatus
    {
        Pending,
        Completed,
        Failed
    }
    public enum TypePayment
    {
        Donate,

    }
}
