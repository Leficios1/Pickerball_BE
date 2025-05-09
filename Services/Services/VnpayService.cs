using AutoMapper;
using Database.DTO.Request;
using Database.DTO.Response;
using Database.Helper;
using Database.Model;
using Microsoft.EntityFrameworkCore;
using Repository.Repository;
using Repository.Repository.Interfeace;
using Services.Services.Interface;
using System.Net;
using System.Transactions;

namespace Services.Services
{
    public class VnpayService : IVnpayService
    {
        private readonly IVnpayRepository _vnpayRepository;
        private readonly ITournamentRegistrationRepository _tenantRegistrationRepository;
        private readonly IPaymentRepository _paymentRepository;
        private readonly ITouramentRepository _tournamentRepository;
        private readonly ISponserTouramentRepository _sponserTouramentRepository;
        private readonly IMapper _mapper;
        public VnpayService(IVnpayRepository vnpayRepository, ITournamentRegistrationRepository tournamentRegistrationRepository, IPaymentRepository paymentRepository, ITouramentRepository tournamentRepository,
            ISponserTouramentRepository sponserTouramentRepository, IMapper mapper)
        {
            _vnpayRepository = vnpayRepository;
            _tenantRegistrationRepository = tournamentRegistrationRepository;
            _paymentRepository = paymentRepository;
            _tournamentRepository = tournamentRepository;
            _sponserTouramentRepository = sponserTouramentRepository;
            _mapper = mapper;
        }
        string vnp_TmnCode = "M9ZAZ0EJ";
        string vnp_HashSecret = "YUCRCHXV6RXOJY7G0V0G0F100DK48F6U";
        string vnp_Url = "https://sandbox.vnpayment.vn/paymentv2/vpcpay.html";
        public async Task<StatusResponse<string>> CallApiByUserId(int UserId, int linkReturn, int? registrationId, int? TouramentId, int? DonateAmount)
        {
            var response = new StatusResponse<string>();
            using (var transaction = new TransactionScope(TransactionScopeAsyncFlowOption.Enabled))
                try
                {
                    string return_URL;
                    switch (linkReturn)
                    {
                        case 1:
                            return_URL = "https://score-pickle.vercel.app/payment-return";
                            break;
                        case 2:
                            return_URL = "http://pickleball.runasp.net/index.html";
                            break;
                        case 3:
                            return_URL = "https://score-pickle.vercel.app/sponsor/sponsorship-return";
                            break;
                        default:
                            return_URL = "http://pickleball.runasp.net/index.html";
                            break;
                    }
                    //string vnp_Url = "https://sandbox.vnpayment.vn/paymentv2/vpcpay.html";
                    //string vnp_TmnCode = "F8V1A5TK";
                    //string vnp_HashSecret = "GCLECYOCZYQLDTIUGHGWZAWPNALXPLOJ";

                    if (string.IsNullOrEmpty(vnp_TmnCode) || string.IsNullOrEmpty(vnp_HashSecret))
                    {
                        throw new Exception("Merchant code or secret key is missing.");
                    }
                    var paymentData = await _paymentRepository.Get().Where(x => x.UserId == UserId && x.TournamentId == TouramentId
                                && x.Status == PaymentStatus.Completed).SingleOrDefaultAsync();
                    if (paymentData != null)
                    {
                        response.Data = null;
                        response.Message = "This user signed this tournament";
                        response.statusCode = HttpStatusCode.BadRequest;
                        return response;
                    }
                    string amount;
                    string vnp_TxnRef;
                    string vnp_Amount;
                    string typePayment;
                    var vnpay = new VnpayLibrary();
                    if (registrationId != null && TouramentId == null)
                    {
                        var registration = await _tenantRegistrationRepository.Get().Where(x => x.Id == registrationId).SingleOrDefaultAsync();
                        if (registration == null)
                        {
                            response.statusCode = HttpStatusCode.NotFound;
                            response.Message = "Registration not found!";
                            return response;
                        }
                        var tourament = await _tournamentRepository.Get().Where(x => x.Id == registration.TournamentId).SingleOrDefaultAsync();
                        if (tourament.IsFree == false)
                        {
                            response.statusCode = HttpStatusCode.Forbidden;
                            response.Message = "This tourament is no need to payment!";
                            return response;
                        }
                        if (registration.IsApproved != TouramentregistrationStatus.Pending)
                        {
                            if (registration.IsApproved == TouramentregistrationStatus.Waiting)
                            {
                                response.statusCode = HttpStatusCode.Forbidden;
                                response.Message = "Registration has been wait for accept from partner!";
                                return response;
                            }
                            else if (registration.IsApproved == TouramentregistrationStatus.Approved)
                            {
                                response.statusCode = HttpStatusCode.BadRequest;
                                response.Message = "Registration has been paid!";
                                return response;
                            }
                        }
                        if (tourament.EntryFee == null || tourament.EntryFee == 0)
                        {
                            response.statusCode = HttpStatusCode.Forbidden;
                            response.Message = "Erro when tourament request Payment but no fee";
                            return response;
                        }
                        amount = ((long)tourament.EntryFee * 100).ToString();
                        vnp_TxnRef = $"{UserId}{registration.Id}{DateTime.Now.ToString("HHmmss")}";
                        vnp_Amount = amount;
                        vnpay.AddRequestData("vnp_OrderInfo", $"fee:{registrationId}");
                    }
                    else if (registrationId == null && TouramentId != null)
                    {
                        if (DonateAmount == null)
                        {
                            response.statusCode = HttpStatusCode.BadRequest;
                            response.Message = "Donate amount is required!";
                            return response;
                        }
                        var tourament = await _tournamentRepository.Get().Where(x => x.Id == TouramentId).SingleOrDefaultAsync();
                        if (tourament == null)
                        {
                            response.statusCode = HttpStatusCode.NotFound;
                            response.Message = "Tourament not found!";
                            return response;
                        }
                        amount = ((long)DonateAmount * 100).ToString();
                        vnp_TxnRef = $"{UserId}{TouramentId}{DateTime.Now.ToString("HHmmss")}";
                        vnp_Amount = amount;
                        vnpay.AddRequestData("vnp_OrderInfo", $"donate:{TouramentId}");

                        typePayment = "donate";
                    }
                    else
                    {
                        response.statusCode = HttpStatusCode.BadRequest;
                        response.Message = "Just one field is required";
                        return response;
                    }
                    TimeZoneInfo vietnamTimeZone = TimeZoneInfo.FindSystemTimeZoneById("SE Asia Standard Time");
                    DateTime vietnamTime = TimeZoneInfo.ConvertTimeFromUtc(DateTime.UtcNow, vietnamTimeZone);

                    vnpay.AddRequestData("vnp_Version", "2.1.0");
                    vnpay.AddRequestData("vnp_Command", "pay");
                    vnpay.AddRequestData("vnp_TmnCode", vnp_TmnCode);
                    vnpay.AddRequestData("vnp_Amount", vnp_Amount);
                    vnpay.AddRequestData("vnp_CreateDate", DateTime.Now.AddMinutes(-20).ToString("yyyyMMddHHmmss"));
                    vnpay.AddRequestData("vnp_CurrCode", "VND");
                    vnpay.AddRequestData("vnp_IpAddr", Utils.GetIpAddress());
                    vnpay.AddRequestData("vnp_Locale", "vn");
                    vnpay.AddRequestData("vnp_OrderType", "order");
                    vnpay.AddRequestData("vnp_ReturnUrl", return_URL);
                    vnpay.AddRequestData("vnp_TxnRef", vnp_TxnRef);
                    vnpay.AddRequestData("vnp_ExpireDate", vietnamTime.AddMinutes(15).ToString("yyyyMMddHHmmss"));
                    //vnpay.AddRequestData("vnp_TypePayment", typePayment);

                    string paymentUrl = vnpay.CreateRequestUrl(vnp_Url, vnp_HashSecret);

                    response.Data = paymentUrl;
                    response.statusCode = HttpStatusCode.OK;
                    response.Message = "Get payment url successfully!";
                    transaction.Complete();
                }
                catch (Exception ex)
                {
                    response.statusCode = HttpStatusCode.InternalServerError;
                    response.Message = ex.Message;
                }
            return response;
        }

        public async Task<StatusResponse<PaymentResponseDTO>> GetVnpayPaymentUrl(VnpayRequestDTO dto)
        {
            var response = new StatusResponse<PaymentResponseDTO>();
            using (var transaction = new TransactionScope(TransactionScopeAsyncFlowOption.Enabled))
                try
                {
                    string vnp_HashSecret = "GCLECYOCZYQLDTIUGHGWZAWPNALXPLOJ";

                    var vnpayData = dto.urlResponse.Split("?")[1];
                    VnpayLibrary vnpay = new VnpayLibrary();

                    foreach (string s in vnpayData.Split("&"))
                    {

                        if (!string.IsNullOrEmpty(s) && s.StartsWith("vnp_"))
                        {
                            vnpay.AddResponseData(s.Split("=")[0], s.Split("=")[1]);
                        }
                    }

                    string orderId = vnpay.GetResponseData("vnp_OrderInfo").Replace("+", " ").Replace("%3A", ":").Split(":")[1].Trim();
                    string vnpayTranId = vnpay.GetResponseData("vnp_TransactionNo");
                    string vnp_ResponseCode = vnpay.GetResponseData("vnp_ResponseCode");
                    string orderInfo = vnpay.GetResponseData("vnp_OrderInfo").Replace("+", " ").Replace("%3A", ":");
                    String vnp_SecureHash = vnpay.GetResponseData("vnp_SecureHash");
                    String TerminalID = vnpay.GetResponseData("vnp_TmnCode");
                    long vnp_Amount = Convert.ToInt64(vnpay.GetResponseData("vnp_Amount")) / 100;
                    String bankCode = vnpay.GetResponseData("vnp_BankCode");
                    string transactionStatus = vnpay.GetResponseData("vnp_TransactionStatus");
                    string txnRef = vnpay.GetResponseData("vnp_TxnRef");
                    string responseCode = vnpay.GetResponseData("vnp_ResponseCode");
                    string bankTranNo = vnpay.GetResponseData("vnp_BankTranNo");
                    string cardType = vnpay.GetResponseData("vnp_CardType");
                    string payDate = vnpay.GetResponseData("vnp_PayDate");
                    string hashSecret = vnpay.GetResponseData("vnp_HashSecret");
                    string[] orderParts = orderInfo.Split(":");
                    if (orderParts.Length != 2) // Kiểm tra nếu không đủ phần tử
                    {
                        throw new Exception("Invalid vnp_OrderInfo format");
                    }
                    string typePayment = orderParts[0].Trim().ToLower(); // "fee" hoặc "donate"


                    var responseCodeMessage = ReturnedErrorMessageResponseCode(responseCode);
                    var transactionStatusMessage = ReturnedErrorMessageTransactionStatus(transactionStatus);
                    VnpayResponseDTO responsePayment = new VnpayResponseDTO()
                    {
                        TransactionId = vnpayTranId,
                        OrderInfo = orderInfo,
                        Amount = vnp_Amount,
                        BankCode = bankCode,
                        BankTranNo = bankTranNo,
                        CardType = cardType,
                        PayDate = payDate,
                        ResponseCode = responseCode,
                        TransactionStatus = transactionStatus,
                        TxnRef = txnRef,
                        //Note = "Payment for Registraion: " + orderId,
                    };
                    if (vnp_ResponseCode == "00" && transactionStatus == "00")
                    {
                        if (typePayment.ToLower() == "Fee".ToLower())
                        {
                            var order = await _tenantRegistrationRepository.Get().Where(x => x.Id == Int32.Parse(orderId)).SingleOrDefaultAsync();
                            if (order == null) throw new Exception("Error to payment: Can not find order to payment");
                            var paymentData = await _paymentRepository.Get().Where(x => x.UserId == order.PlayerId && x.TournamentId == order.TournamentId
                                                                                && x.Status == PaymentStatus.Completed).SingleOrDefaultAsync();
                            if (paymentData != null)
                            {
                                response.Data = null;
                                response.Message = "This user signed this tournament";
                                response.statusCode = HttpStatusCode.BadRequest;
                                return response;
                            }
                            order.IsApproved = TouramentregistrationStatus.Approved;
                            Payments payment = new Payments()
                            {
                                UserId = order.PlayerId,
                                TournamentId = order.TournamentId,
                                Amount = vnp_Amount,
                                Note = "Payment for Registraion: " + orderId,
                                PaymentMethod = "VNPAY",
                                Status = PaymentStatus.Completed,
                                Type = TypePayment.Fee,
                                PaymentDate = DateTime.UtcNow
                            };
                            _tenantRegistrationRepository.Update(order);
                            await _paymentRepository.AddAsync(payment);
                            await _tenantRegistrationRepository.SaveChangesAsync();
                            await _paymentRepository.SaveChangesAsync();
                            PaymentResponseDTO paymentResponse = new PaymentResponseDTO()
                            {
                                ResponseCodeMessage = responseCodeMessage,
                                TransactionStatusMessage = transactionStatusMessage,
                                VnPayResponse = responsePayment
                            };
                            response.Data = paymentResponse;
                            response.statusCode = HttpStatusCode.OK;
                            transaction.Complete();
                        }
                        else if (typePayment.ToLower() == "Donate".ToLower())
                        {
                            //var order = await _tenantRegistrationRepository.Get().Where(x => x.Id == Int32.Parse(orderId)).SingleOrDefaultAsync();
                            //if (order == null) throw new Exception("Error to payment: Can not find order to payment");
                            var tournament = await _tournamentRepository.Get().Where(x => x.Id == Int32.Parse(orderId)).SingleOrDefaultAsync();
                            if (tournament == null)
                                throw new Exception("Error: Tournament not found for donation");

                            SponnerTourament sponsorDonation = new SponnerTourament()
                            {
                                SponsorId = dto.userId, // 🔥 Ai donate?
                                TournamentId = tournament.Id,
                                SponsorAmount = vnp_Amount,
                                SponsorNote = "Donation for Tournament: " + orderId,
                                CreatedAt = DateTime.UtcNow
                            };
                            tournament.TotalPrize += vnp_Amount;
                            Payments payment = new Payments()
                            {
                                UserId = dto.userId,
                                TournamentId = tournament.Id,
                                Amount = vnp_Amount,
                                Note = "Donate for Tourament: " + tournament.Id,
                                PaymentMethod = "VNPAY",
                                Status = PaymentStatus.Completed,
                                Type = TypePayment.Donate,
                                PaymentDate = DateTime.UtcNow
                            };
                            _tournamentRepository.Update(tournament);
                            await _sponserTouramentRepository.AddAsync(sponsorDonation);
                            await _paymentRepository.AddAsync(payment);
                            await _sponserTouramentRepository.SaveChangesAsync();
                            await _tournamentRepository.SaveChangesAsync();
                            await _paymentRepository.SaveChangesAsync();
                            PaymentResponseDTO paymentResponse = new PaymentResponseDTO()
                            {
                                ResponseCodeMessage = responseCodeMessage,
                                TransactionStatusMessage = transactionStatusMessage,
                                VnPayResponse = responsePayment
                            };
                            response.Data = paymentResponse;
                            response.statusCode = HttpStatusCode.OK;
                            transaction.Complete();
                        }
                        else
                        {
                            response.statusCode = HttpStatusCode.BadRequest;
                            response.Message = "Payment failed!";
                        }
                    }
                    else if (vnp_ResponseCode != "00" && transactionStatus != "00" || vnp_ResponseCode == "07" && transactionStatus == "07")
                    {
                        if (typePayment.ToLower() == "Fee".ToLower())
                        {
                            var order = await _tenantRegistrationRepository.Get().Where(x => x.Id == Int32.Parse(orderId)).SingleOrDefaultAsync();
                            if (order == null) throw new Exception("Error to payment: Can not find order to payment");
                            var paymentData = await _paymentRepository.Get().Where(x => x.UserId == order.PlayerId && x.TournamentId == order.TournamentId
                                                                                && x.Status == PaymentStatus.Completed).SingleOrDefaultAsync();
                            if (paymentData != null)
                            {
                                response.Data = null;
                                response.Message = "This user signed this tournament";
                                response.statusCode = HttpStatusCode.BadRequest;
                                return response;
                            }
                            else
                            {
                                var tournamentData = await _tournamentRepository.GetById(order.TournamentId);
                                if (tournamentData == null)
                                {
                                    response.Data = null;
                                    response.statusCode = HttpStatusCode.BadRequest;
                                    response.Message = "Not found Tournament";
                                    return response;
                                }
                                if (tournamentData.Type == TournamentType.SinglesFemale || tournamentData.Type == TournamentType.SinglesMale)
                                {
                                    _tenantRegistrationRepository.Delete(order);
                                    await _tenantRegistrationRepository.SaveChangesAsync();
                                }
                                else
                                {
                                    var tournamentSendRequest = await _tenantRegistrationRepository.Get().Include(x => x.TournamentTeams).Where(x => x.Id == int.Parse(orderId)).SingleOrDefaultAsync();
                                    _tenantRegistrationRepository.Delete(tournamentSendRequest);
                                    await _tenantRegistrationRepository.SaveChangesAsync();
                                }
                            }
                        }
                        else if (typePayment.ToLower() == "Donate".ToLower())
                        {
                            response.statusCode = HttpStatusCode.BadRequest;
                            response.Message = "Payment failed!";
                        }
                        response.statusCode = HttpStatusCode.OK;
                        transaction.Complete();
                    }
                }
                catch (Exception ex)
                {
                    response.statusCode = HttpStatusCode.InternalServerError;
                    response.Message = ex.Message;
                }
            return response;
        }
        private string ReturnedErrorMessageTransactionStatus(string code)
        {
            switch (code)
            {
                case "00": return "Giao dịch thành công";
                case "01": return "Giao dịch chưa hoàn tất";
                case "02": return "Giao dịch bị lỗi";
                case "04": return "Giao dịch đảo (Khách hàng đã bị trừ tiền tại Ngân hàng nhưng GD chưa thành công ở VNPAY)";
                case "05": return "VNPAY đang xử lý giao dịch này (GD hoàn tiền)";
                case "06": return "VNPAY đã gửi yêu cầu hoàn tiền sang Ngân hàng (GD hoàn tiền)";
                case "07": return "Giao dịch bị nghi ngờ gian lận";
                case "09": return "GD Hoàn trả bị từ chối";
                default: return "Mã lỗi không hợp lệ";
            }
        }
        private string ReturnedErrorMessageResponseCode(string code)
        {
            switch (code)
            {
                case "00": return "Giao dịch thành công";
                case "07": return "Trừ tiền thành công. Giao dịch bị nghi ngờ (liên quan tới lừa đảo, giao dịch bất thường).";
                case "09": return "Giao dịch không thành công do: Thẻ/Tài khoản của khách hàng chưa đăng ký dịch vụ InternetBanking tại ngân hàng.";
                case "10": return "Giao dịch không thành công do: Khách hàng xác thực thông tin thẻ/tài khoản không đúng quá 3 lần.";
                case "11": return "Giao dịch không thành công do: Đã hết hạn chờ thanh toán. Xin quý khách vui lòng thực hiện lại giao dịch.";
                case "12": return "Giao dịch không thành công do: Thẻ/Tài khoản của khách hàng bị khóa.";
                case "13": return "Giao dịch không thành công do Quý khách nhập sai mật khẩu xác thực giao dịch (OTP). Xin quý khách vui lòng thực hiện lại giao dịch.";
                case "24": return "Giao dịch không thành công do: Khách hàng hủy giao dịch.";
                case "51": return "Giao dịch không thành công do: Tài khoản của quý khách không đủ số dư để thực hiện giao dịch.";
                case "65": return "Giao dịch không thành công do: Tài khoản của Quý khách đã vượt quá hạn mức giao dịch trong ngày.";
                case "75": return "Ngân hàng thanh toán đang bảo trì.";
                case "79": return "Giao dịch không thành công do: KH nhập sai mật khẩu thanh toán quá số lần quy định. Xin quý khách vui lòng thực hiện lại giao dịch.";
                case "99": return "Các lỗi khác (lỗi còn lại, không có trong danh sách mã lỗi đã liệt kê).";
                default: return "Mã lỗi không hợp lệ";
            }
        }

        public async Task<StatusResponse<List<BillResponseDTO>>> GetAllBillByTourament(int TouramentId)
        {
            var response = new StatusResponse<List<BillResponseDTO>>();
            try
            {
                var data = await _paymentRepository.Get().Where(x => x.TournamentId == TouramentId).ToListAsync();
                if (data == null)
                {
                    response.statusCode = HttpStatusCode.NotFound;
                    response.Message = "Bill not found!";
                    return response;
                }
                response.Data = _mapper.Map<List<BillResponseDTO>>(data);
                response.statusCode = HttpStatusCode.OK;
                response.Message = "Get all bill successfully!";
            }
            catch (Exception ex)
            {
                response.statusCode = HttpStatusCode.InternalServerError;
                response.Message = ex.Message;
            }
            return response;
        }

        public async Task<StatusResponse<BillResponseDTO>> GetBillById(int BillId)
        {
            var response = new StatusResponse<BillResponseDTO>();
            try
            {
                var data = await _paymentRepository.Get().Where(x => x.Id == BillId).SingleOrDefaultAsync();
                if (data == null)
                {
                    response.statusCode = HttpStatusCode.NotFound;
                    response.Message = "Bill not found!";
                    return response;
                }
                response.Data = _mapper.Map<BillResponseDTO>(data);
                response.statusCode = HttpStatusCode.OK;
                response.Message = "Get bill successfully!";
            }
            catch (Exception ex)
            {
                response.statusCode = HttpStatusCode.InternalServerError;
                response.Message = ex.Message;
            }
            return response;
        }

        public async Task<StatusResponse<List<BillResponseDTO>>> GetAllBillBySponnerId(int SponnerId)
        {
            var response = new StatusResponse<List<BillResponseDTO>>();
            try
            {
                var data = await _paymentRepository.Get().Where(x => x.UserId == SponnerId).ToListAsync();
                if (data == null)
                {
                    response.statusCode = HttpStatusCode.NotFound;
                    response.Message = "Bill not found!";
                    return response;
                }
                response.Data = _mapper.Map<List<BillResponseDTO>>(data);
                response.statusCode = HttpStatusCode.OK;
                response.Message = "Get all bill successfully!";
            }
            catch (Exception ex)
            {
                response.statusCode = HttpStatusCode.InternalServerError;
                response.Message = ex.Message;
            }
            return response;
        }

        public async Task<StatusResponse<List<BillResponseDTO>>> GetAll()
        {
            var response = new StatusResponse<List<BillResponseDTO>>();
            try
            {
                var data = await _paymentRepository.GetAll();
                response.Data = _mapper.Map<List<BillResponseDTO>>(data);
                response.statusCode = HttpStatusCode.OK;
                response.Message = "Get all bill successfully!";
            }
            catch (Exception ex)
            {
                response.statusCode = HttpStatusCode.InternalServerError;
                response.Message = ex.Message;
            }
            return response;
        }
    }
}
