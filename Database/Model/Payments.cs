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

        [ForeignKey("User")]
        public int UserId { get; set; }
        public User User { get; set; }

        [ForeignKey("Tournament")]
        public int TournamentId { get; set; }
        public Tournaments Tournament { get; set; }

        public decimal Amount { get; set; }
        public string? Note { get; set; }
        public string? PaymentMethod { get; set; }
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
        Fee,
        Sponsor
    }
}
