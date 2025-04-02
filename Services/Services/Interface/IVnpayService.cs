using Database.DTO.Request;
using Database.DTO.Response;
using Database.Helper;

namespace Services.Services.Interface
{
    public interface IVnpayService
    {
        Task<StatusResponse<PaymentResponseDTO>> GetVnpayPaymentUrl(VnpayRequestDTO paymentRequest);
        Task<StatusResponse<string>> CallApiByUserId(int UserId, int linkReturn, int? registrationId, int? TouramentId, int? DonateAmount);
        Task<StatusResponse<List<BillResponseDTO>>> GetAllBillByTourament(int TouramentId);
        Task<StatusResponse<BillResponseDTO>> GetBillById(int BillId);
        Task<StatusResponse<List<BillResponseDTO>>> GetAllBillBySponnerId(int SponnerId);
        Task<StatusResponse<List<BillResponseDTO>>> GetAll();
    }
}
