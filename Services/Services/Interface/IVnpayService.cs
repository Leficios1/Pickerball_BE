using Database.DTO.Request;
using Database.DTO.Response;
using Database.Helper;

namespace Services.Services.Interface
{
    public interface IVnpayService
    {
        Task<StatusResponse<string>> GetVnpayPaymentUrl(VnpayRequestDTO paymentRequest);
        Task<StatusResponse<string>> CallApiByUserId(int UserId, int linkReturn, int registrationId);
    }
}
