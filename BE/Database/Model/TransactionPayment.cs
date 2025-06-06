using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Database.Model
{
    public class TransactionPayment
    {
        public string? BankTranNo { get; set; }
        public DateTime? PayDate { get; set; }
        public string? OrderInfo { get; set; }
        public string? ResponseCode { get; set; }
        [Key]
        public string? TransactionId { get; set; }
        public string? TransactionStatus { get; set; }
        public string? CardType { get; set; }
        public string? TxnRef { get; set; }
        public long Amount { get; set; }
        public string? BankCode { get; set; }
        public int OrderId { get; set; }
        public int UserId { get; set; }
        public string? Note { get; set; }
    }
}
