//using Database.DTO.Request;
//using Database.DTO.Response;
//using Database.Helper;
//using Database.Model;
//using Microsoft.EntityFrameworkCore;
//using Repository.Repository;
//using Repository.Repository.Interfeace;
//using Services.Services.Interface;
//using System.Net;

//namespace Services.Services
//{
//    public class VnpayService : IVnpayService
//    {
//        private readonly IVnpayRepository _vnpayRepository;
//        private readonly ITournamentRegistrationRepository _tenantRegistrationRepository;
//        private readonly IPaymentRepository _paymentRepository;
//        public VnpayService(IVnpayRepository vnpayRepository, ITournamentRegistrationRepository tournamentRegistrationRepository, IPaymentRepository paymentRepository)
//        {
//            _vnpayRepository = vnpayRepository;
//            _tenantRegistrationRepository = tournamentRegistrationRepository;
//            _paymentRepository = paymentRepository;
//        }

//        public async Task<StatusResponse<string>> CallApiByUserId(int UserId, int linkReturn, int TouramentId)
//        {
//            var response = new StatusResponse<string>();
//            try
//            {
//                string return_URL;
//                switch (linkReturn)
//                {
//                    case 1:
//                        return_URL = "https://localhost:44300/registration";
//                        break;
//                    case 2:
//                        return_URL = "https://localhost:44300/registration";
//                        break;
//                    default:
//                        return_URL = "https://localhost:44300/registration";
//                        break;
//                }
//                string vnp_Url = "https://sandbox.vnpayment.vn/paymentv2/vpcpay.html";
//                string vnp_TmnCode = "F8V1A5TK";
//                string vnp_HashSecret = "GCLECYOCZYQLDTIUGHGWZAWPNALXPLOJ";

//                if (string.IsNullOrEmpty(vnp_TmnCode) || string.IsNullOrEmpty(vnp_HashSecret))
//                {
//                    throw new Exception("Merchant code or secret key is missing.");
//                }

//            }
//            catch (Exception ex)
//            {
//                response.statusCode = HttpStatusCode.InternalServerError;
//                response.Message = ex.Message;
//            }
//            return response;
//        }

//        public async Task<StatusResponse<PaymentResponseDTO>> GetVnpayPaymentUrl(VnpayRequestDTO dto)
//        {
//            var response = new StatusResponse<PaymentResponseDTO>();
//            try
//            {
//                string vnp_HashSecret = "GCLECYOCZYQLDTIUGHGWZAWPNALXPLOJ";

//                var vnpayData = dto.urlResponse.Split("?")[1];
//                VnpayLibrary vnpay = new VnpayLibrary();

//                foreach (string s in vnpayData.Split("&"))
//                {

//                    if (!string.IsNullOrEmpty(s) && s.StartsWith("vnp_"))
//                    {
//                        vnpay.AddResponseData(s.Split("=")[0], s.Split("=")[1]);
//                    }
//                }


//                string orderId = vnpay.GetResponseData("vnp_OrderInfo").Replace("+", " ").Replace("%3A", ":").Split(":")[1].Trim();
//                string vnpayTranId = vnpay.GetResponseData("vnp_TransactionNo");
//                string vnp_ResponseCode = vnpay.GetResponseData("vnp_ResponseCode");
//                string orderInfo = vnpay.GetResponseData("vnp_OrderInfo").Replace("+", " ").Replace("%3A", ":");
//                String vnp_SecureHash = vnpay.GetResponseData("vnp_SecureHash");
//                String TerminalID = vnpay.GetResponseData("vnp_TmnCode");
//                long vnp_Amount = Convert.ToInt64(vnpay.GetResponseData("vnp_Amount")) / 100;
//                String bankCode = vnpay.GetResponseData("vnp_BankCode");
//                string transactionStatus = vnpay.GetResponseData("vnp_TransactionStatus");
//                string txnRef = vnpay.GetResponseData("vnp_TxnRef");
//                string responseCode = vnpay.GetResponseData("vnp_ResponseCode");
//                string bankTranNo = vnpay.GetResponseData("vnp_BankTranNo");
//                string cardType = vnpay.GetResponseData("vnp_CardType");
//                string payDate = vnpay.GetResponseData("vnp_PayDate");
//                string hashSecret = vnpay.GetResponseData("vnp_HashSecret");

//                var responseCodeMessage = ReturnedErrorMessageResponseCode(responseCode);
//                var transactionStatusMessage = ReturnedErrorMessageTransactionStatus(transactionStatus);
//                VnpayResponseDTO responsePayment = new VnpayResponseDTO()
//                {
//                    TransactionId = vnpayTranId,
//                    OrderInfo = orderInfo,
//                    Amount = vnp_Amount,
//                    BankCode = bankCode,
//                    BankTranNo = bankTranNo,
//                    CardType = cardType,
//                    PayDate = payDate,
//                    ResponseCode = responseCode,
//                    TransactionStatus = transactionStatus,
//                    TxnRef = txnRef
//                };
//                if (vnp_ResponseCode == "00" && transactionStatus == "00")
//                {
//                    var order = await _tenantRegistrationRepository.Get().Where(x => x.Id == Int32.Parse(orderId)).FirstOrDefaultAsync();
//                    if (order == null) throw new Exception("Error to payment: Can not find order to payment");
//                    order.i = 1;
//                    _orderRepository.Update(order);
//                    await _orderRepository.SaveChangesAsync();
//                    if (order.OrdersDetail != null)
//                        foreach (var item in order.OrdersDetail)
//                        {
//                            var product = item.Product;
//                            product.quantity -= item.Quantity;
//                            _productRepository.Update(product);
//                        }
//                    await _productRepository.SaveChangesAsync();
//                }


//            }
//            catch (Exception ex)
//            {
//                response.statusCode = HttpStatusCode.InternalServerError;
//                response.Message = ex.Message;
//                return response;
//            }
//        }
//        private string ReturnedErrorMessageTransactionStatus(string code)
//        {
//            switch (code)
//            {
//                case "00": return "Giao dịch thành công";
//                case "01": return "Giao dịch chưa hoàn tất";
//                case "02": return "Giao dịch bị lỗi";
//                case "04": return "Giao dịch đảo (Khách hàng đã bị trừ tiền tại Ngân hàng nhưng GD chưa thành công ở VNPAY)";
//                case "05": return "VNPAY đang xử lý giao dịch này (GD hoàn tiền)";
//                case "06": return "VNPAY đã gửi yêu cầu hoàn tiền sang Ngân hàng (GD hoàn tiền)";
//                case "07": return "Giao dịch bị nghi ngờ gian lận";
//                case "09": return "GD Hoàn trả bị từ chối";
//                default: return "Mã lỗi không hợp lệ";
//            }
//        }
//        private string ReturnedErrorMessageResponseCode(string code)
//        {
//            switch (code)
//            {
//                case "00": return "Giao dịch thành công";
//                case "07": return "Trừ tiền thành công. Giao dịch bị nghi ngờ (liên quan tới lừa đảo, giao dịch bất thường).";
//                case "09": return "Giao dịch không thành công do: Thẻ/Tài khoản của khách hàng chưa đăng ký dịch vụ InternetBanking tại ngân hàng.";
//                case "10": return "Giao dịch không thành công do: Khách hàng xác thực thông tin thẻ/tài khoản không đúng quá 3 lần.";
//                case "11": return "Giao dịch không thành công do: Đã hết hạn chờ thanh toán. Xin quý khách vui lòng thực hiện lại giao dịch.";
//                case "12": return "Giao dịch không thành công do: Thẻ/Tài khoản của khách hàng bị khóa.";
//                case "13": return "Giao dịch không thành công do Quý khách nhập sai mật khẩu xác thực giao dịch (OTP). Xin quý khách vui lòng thực hiện lại giao dịch.";
//                case "24": return "Giao dịch không thành công do: Khách hàng hủy giao dịch.";
//                case "51": return "Giao dịch không thành công do: Tài khoản của quý khách không đủ số dư để thực hiện giao dịch.";
//                case "65": return "Giao dịch không thành công do: Tài khoản của Quý khách đã vượt quá hạn mức giao dịch trong ngày.";
//                case "75": return "Ngân hàng thanh toán đang bảo trì.";
//                case "79": return "Giao dịch không thành công do: KH nhập sai mật khẩu thanh toán quá số lần quy định. Xin quý khách vui lòng thực hiện lại giao dịch.";
//                case "99": return "Các lỗi khác (lỗi còn lại, không có trong danh sách mã lỗi đã liệt kê).";
//                default: return "Mã lỗi không hợp lệ";
//            }
//        }
//    }
//}
