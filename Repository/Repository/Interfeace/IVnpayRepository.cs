using Database.DTO.Request;
using Database.Helper;

namespace Repository.Repository.Interfeace
{
    public interface IVnpayRepository
    {
        string GetVnpayPaymentUrl(VnpayRequestDTO payRequest);
        
    }
}
