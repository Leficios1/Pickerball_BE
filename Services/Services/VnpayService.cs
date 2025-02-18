using Database.DTO.Request;
using Database.DTO.Response;
using Database.Helper;
using Database.Model;
using Repository.Repository;
using Repository.Repository.Interfeace;
using Services.Services.Interface;
using System.Net;

namespace Services.Services
{
    public class VnpayService : IVnpayService
    {
        private readonly IVnpayRepository _vnpayRepository;
        public VnpayService(IVnpayRepository vnpayRepository)
        {
            _vnpayRepository = vnpayRepository;
        }

        public async Task<StatusResponse<string>> GetVnpayPaymentUrl(VnpayRequestDTO paymentRequest)
        {
            var response = new StatusResponse<string>();
            try
            {
                var url = _vnpayRepository.GetVnpayPaymentUrl(paymentRequest);

                response.Data = url;
                response.statusCode = HttpStatusCode.OK;
                response.Message = "Get vnpay url successfully!";
                return response;
            }
            catch (Exception ex)
            {
                response.statusCode = HttpStatusCode.InternalServerError;
                response.Message = ex.Message;
                return response;
            }
        }
    }
}
