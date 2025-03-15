using Database.Model;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Database.DTO.Response
{
    public class PaymentResponseDTO
    {
        public string? ResponseCodeMessage { get; set; }
        public string? TransactionStatusMessage { get; set; }

        public VnpayResponseDTO? VnPayResponse { get; set; }
    }
    public class BillResponseDTO
    {
        public int Id { get; set; }

        public int UserId { get; set; }
        public int TournamentId { get; set; }

        public decimal Amount { get; set; }
        public string? Note { get; set; }
        public string? PaymentMethod { get; set; }
        public PaymentStatus Status { get; set; }
        public TypePayment Type { get; set; }
        public DateTime PaymentDate { get; set; }
    }
}
