using Database.DTO.Request;
using Database.Helper;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Options;
using Repository.Repository.Interfeace;

namespace Repository.Repository
{
    public class VnpayRepository : IVnpayRepository
    {
        private readonly IHttpContextAccessor _httpContextAccessor;
        private readonly VnpayConfig _vnpayConfig;
        public VnpayRepository(IHttpContextAccessor httpContextAccessor, IOptions<VnpayConfig> vnpayConfigOptions)
        {
            _httpContextAccessor = httpContextAccessor;
            _vnpayConfig = vnpayConfigOptions.Value;
        }
        public string GetVnpayPaymentUrl(VnpayRequestDTO payRequest)
        {
            //Get Config Info
            string vnp_Returnurl = _vnpayConfig.ReturnUrl;
            string vnp_Url = _vnpayConfig.PaymentUrl;
            string vnp_TmnCode = _vnpayConfig.TmnCode;
            string vnp_HashSecret = _vnpayConfig.HashSecret;
            string vnp_Version = _vnpayConfig.Version;
            string vnp_Command = _vnpayConfig.Command;
            string vnp_Locale = _vnpayConfig.Locale;

            //Tạo status là đang chờ(Pending) để lưu db
            //Save registration to db

            //Build URL for VNPAY
            VnpayLibrary vnpay = new VnpayLibrary();
            //vnpay.AddRequestData("vnp_Amount", (payRequest.Amount * 100).ToString()); //Số tiền thanh toán. Số tiền không mang các ký tự phân tách thập phân, phần nghìn, ký tự tiền tệ. Để gửi số tiền thanh toán là 100,000 VND (một trăm nghìn VNĐ) thì merchant cần nhân thêm 100 lần (khử phần thập phân), sau đó gửi sang VNPAY là: 10000000
            //vnpay.AddRequestData("vnp_Command", vnp_Command);
            //vnpay.AddRequestData("vnp_CreateDate", payRequest.CreatedDate.ToString("yyyyMMddHHmmss"));
            //vnpay.AddRequestData("vnp_CurrCode", "VND");

            //var ipAddress = _httpContextAccessor.HttpContext?.Connection.RemoteIpAddress?.ToString();
            //vnpay.AddRequestData("vnp_IpAddr", ipAddress);
            //vnpay.AddRequestData("vnp_Locale", vnp_Locale);
            //vnpay.AddRequestData("vnp_OrderInfo", payRequest.Id.ToString());
            //vnpay.AddRequestData("vnp_OrderType", "other");
            //vnpay.AddRequestData("vnp_ReturnUrl", vnp_Returnurl);
            //vnpay.AddRequestData("vnp_TmnCode", vnp_TmnCode);
            //vnpay.AddRequestData("vnp_TxnRef", payRequest.Id.ToString()); // Mã tham chiếu của giao dịch tại hệ thống của merchant. Mã này là duy nhất dùng để phân biệt các đơn hàng gửi sang VNPAY. Không được trùng lặp trong ngày
            //vnpay.AddRequestData("vnp_Version", vnp_Version);

            string paymentUrl = vnpay.CreateRequestUrl(vnp_Url, vnp_HashSecret);

            return paymentUrl;
        }
    }
}
