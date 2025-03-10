using System;
using System.Collections.Generic;
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
}
