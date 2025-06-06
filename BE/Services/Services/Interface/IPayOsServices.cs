using Database.DTO.Response;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Net.payOS.Types;
using Microsoft.AspNetCore.Mvc;


namespace Services.Services.Interface
{
    public interface IPayOsServices
    {
        public Task<StatusResponse<string>> CheckoutForSponner(int userId, int tourId, decimal Amount, int linkReturn);
        public Task<StatusResponse<string>> PaymentForPlayer(int userId, int tourId, int linkReturnUrl, int registrationId);
        public Task<StatusResponse<PaymentLinkInformation>> getPaymentInfo(long orderCode); 
    }
}
