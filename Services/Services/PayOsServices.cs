using Database.DTO.PayOsDTO;
using Microsoft.AspNetCore.Mvc;
using Net.payOS;
using Net.payOS.Types;
using Services.Services.Interface;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Runtime;
using System.Text;
using System.Text.Json;
using System.Threading.Tasks;
using Microsoft.Extensions.Options;
using Net.payOS.Types;
using Net.payOS;
using Microsoft.Extensions.Configuration;
using Repository.Repository.Interfeace;
using Database.DTO.Response;
using Database.Model;
using Repository.Repository;
using System.Net;
using System.Transactions;
using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Http.HttpResults;
using System.Text.RegularExpressions;

namespace Services.Services
{
    public class PayOsServices : IPayOsServices
    {
        private readonly PayOS _payOs;
        private readonly ITouramentRepository _touramentRepository;
        private readonly IConfiguration _configuration;
        private readonly ITournamentRegistrationRepository _tournamentRegistrationRepository;
        private readonly IPaymentRepository _paymentRepository;
        private readonly IUserRepository _userRepository;
        private readonly ISponserTouramentRepository _sponserTouramentRepository;
        public PayOsServices(IConfiguration configuration, ITouramentRepository touramentRepository, ITournamentRegistrationRepository tournamentRegistrationRepository,
            IPaymentRepository paymentRepository, IUserRepository userRepository, ISponserTouramentRepository sponserTouramentRepository)
        {
            _configuration = configuration;
            var clientId = _configuration["Environment:PAYOS_CLIENT_ID"];
            var apiKey = _configuration["Environment:PAYOS_API_KEY"];
            var checksumKey = _configuration["Environment:PAYOS_CHECKSUM_KEY"];

            _payOs = new PayOS(clientId, apiKey, checksumKey);
            _touramentRepository = touramentRepository;
            _tournamentRegistrationRepository = tournamentRegistrationRepository;
            _paymentRepository = paymentRepository;
            _userRepository = userRepository;
            _sponserTouramentRepository = sponserTouramentRepository;
        }

        public async Task<StatusResponse<string>> CheckoutForSponner(int userId, int tourId, decimal Amount, int linkReturn)
        {
            var response = new StatusResponse<string>();
            try
            {
                string return_URL;
                switch (linkReturn)
                {
                    case 1:
                        return_URL = "http://localhost:5173/payment-return";
                        break;
                    case 2:
                        return_URL = "https://pickbleballcapston-a4eagpasc9fbeeb8.eastasia-01.azurewebsites.net/index.html";
                        break;
                    default:
                        return_URL = "https://pickbleballcapston-a4eagpasc9fbeeb8.eastasia-01.azurewebsites.net/index.html";
                        break;
                }
                string cancel_URL = "https://pickbleballcapston-a4eagpasc9fbeeb8.eastasia-01.azurewebsites.net/index.html";
                long orderCode = DateTimeOffset.UtcNow.ToUnixTimeMilliseconds();
                var amountInt = (int)Math.Round(Amount);

                var touramentData = await _touramentRepository.GetById(tourId);
                if (touramentData == null || touramentData.Status == "Reject")
                {
                    response.statusCode = HttpStatusCode.BadRequest;
                    response.Message = "This tourament can't sponsor";
                    return response ;
                }
                ItemData item = new ItemData("Sponsor", tourId, (int)Amount);
                List<ItemData> items = new List<ItemData> { item };
                string description = $"Donate{tourId}User{userId}End";
                var userInfo = await _userRepository.GetById(userId);
                PaymentData paymentData = new PaymentData(
                    orderCode,
                    amountInt,
                    description,
                    items,
                    cancel_URL,
                    return_URL,
                    null, // signature
                    null, // buyerName
                    null, // buyerEmail
                    userInfo.PhoneNumber,
                    null, // buyerAddress
                    null  // expiredAt
                );

                var paymentResponse = await _payOs.createPaymentLink(paymentData);

                response.Data = paymentResponse.checkoutUrl;
                response.statusCode = HttpStatusCode.OK;
                response.Message = "Get Payment Link Successful";
                return response;
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }

        public async Task<StatusResponse<PaymentLinkInformation>> getPaymentInfo(long orderCode)
        {
            var response = new StatusResponse<PaymentLinkInformation>();
            using (var transaction = new TransactionScope(TransactionScopeAsyncFlowOption.Enabled))
                try
                {
                    // 1. Gọi PayOS để lấy thông tin thanh toán
                    var paymentLinkInformation = await _payOs.getPaymentLinkInformation(orderCode);

                    if (paymentLinkInformation == null)
                        throw new Exception("Cannot retrieve payment information.");

                    if (paymentLinkInformation.status != "PAID")
                        throw new Exception("Payment not completed.");

                    // 2. Parse orderInfo hoặc note để phân biệt loại thanh toán
                    // Bạn cần đảm bảo khi tạo PaymentLink, bạn đã gắn OrderCode theo format: Fee:orderId hoặc Donate:tourId
                    var orderInfo = paymentLinkInformation.transactions.FirstOrDefault(); // hoặc Note nếu bạn lưu vào note
                    if (orderInfo == null)
                        throw new Exception("Missing order information.");

                    var description = orderInfo.description ?? "";
                    description = description.Replace(" ", ""); // xóa khoảng trắng cho chắc

                    var match = Regex.Match(description, @"(Donate|Fee)(\d+)User(\d+)", RegexOptions.IgnoreCase);
                    if (!match.Success)
                    {
                        throw new Exception("Invalid order information format.");
                    }

                    string typeCode = match.Groups[1].Value.ToUpper(); // D hoặc F
                    int orderId = int.Parse(match.Groups[2].Value); // tournamentId hoặc registrationId
                    int userId = int.Parse(match.Groups[3].Value);  // userId

                    string typePayment = typeCode == "Donate".ToUpper() ? "donate" : "fee";

                    long amount = (long)paymentLinkInformation.amountPaid;
                    if(userId == 0)
                    {
                        throw new Exception("Error when parts UserId");
                    }
                    // 3. Tùy theo loại thanh toán
                    if (typePayment == "fee")
                    {

                        var registration = await _tournamentRegistrationRepository.Get().Where(x => x.Id == orderId).SingleOrDefaultAsync();
                        if (registration == null)
                            throw new Exception("Cannot find registration.");

                        registration.IsApproved = TouramentregistrationStatus.Approved;
                        var touramentData = await _touramentRepository.GetById(registration.TournamentId);

                        var payment = new Payments()
                        {
                            UserId = registration.PlayerId,
                            TournamentId = registration.TournamentId,
                            Amount = amount,
                            Note = $"Payment for Tourament: {touramentData.Name}",
                            PaymentMethod = "PayOS",
                            Status = PaymentStatus.Completed,
                            Type = TypePayment.Fee,
                            PaymentDate = DateTime.UtcNow
                        };

                        _tournamentRegistrationRepository.Update(registration);
                        await _paymentRepository.AddAsync(payment);

                        await _tournamentRegistrationRepository.SaveChangesAsync();
                        await _paymentRepository.SaveChangesAsync();
                    }
                    else if (typePayment == "donate")
                    {
                        var tournament = await _touramentRepository.Get().Where(x => x.Id == orderId).SingleOrDefaultAsync();
                        if (tournament == null)
                            throw new Exception("Tournament not found.");

                        tournament.TotalPrize += amount;

                        var sponsor = new SponnerTourament()
                        {
                            SponsorId = userId, // CustomerId bên PayOS nếu có
                            TournamentId = tournament.Id,
                            SponsorAmount = amount,
                            SponsorNote = $"Donation for Tournament: {tournament.Name}",
                            CreatedAt = DateTime.UtcNow
                        };

                        var payment = new Payments()
                        {
                            UserId = userId,
                            TournamentId = tournament.Id,
                            Amount = amount,
                            Note = $"Donation for Tournament: {tournament.Name}",
                            PaymentMethod = "PayOS",
                            Status = PaymentStatus.Completed,
                            Type = TypePayment.Donate,
                            PaymentDate = DateTime.UtcNow
                        };

                        _touramentRepository.Update(tournament);
                        await _sponserTouramentRepository.AddAsync(sponsor);
                        await _paymentRepository.AddAsync(payment);

                        await _sponserTouramentRepository.SaveChangesAsync();
                        await _touramentRepository.SaveChangesAsync();
                        await _paymentRepository.SaveChangesAsync();
                    }
                    else
                    {
                        throw new Exception("Unknown payment type.");
                    }

                    // 4. Thành công
                    response.Data = paymentLinkInformation;
                    response.statusCode = HttpStatusCode.OK;
                    response.Message = "Payment successfully processed!";
                    transaction.Complete();
                    return response;
                }
                catch (Exception ex)
                {
                    response.statusCode = HttpStatusCode.InternalServerError;
                    response.Message = ex.Message;
                    return response;
                }
        }

        public async Task<StatusResponse<string>> PaymentForPlayer(int userId, int tourId, int linkReturnUrl, int registrationId)
        {
            var response = new StatusResponse<string>();    
            try
            {
                string return_URL;
                switch (linkReturnUrl)
                {
                    case 1:
                        return_URL = "http://localhost:5173/payment-return";
                        break;
                    case 2:
                        return_URL = "https://pickbleballcapston-a4eagpasc9fbeeb8.eastasia-01.azurewebsites.net/index.html";
                        break;
                    default:
                        return_URL = "https://pickbleballcapston-a4eagpasc9fbeeb8.eastasia-01.azurewebsites.net/index.html";
                        break;
                }
                string cancel_URL = "https://pickbleballcapston-a4eagpasc9fbeeb8.eastasia-01.azurewebsites.net/index.html";
                long orderCode = DateTimeOffset.UtcNow.ToUnixTimeMilliseconds();

                var touramentData = await _touramentRepository.GetById(tourId);
                if (touramentData == null || touramentData.IsFree == false || touramentData.EntryFee == null || touramentData.Status == "Reject")
                {
                    response.statusCode=HttpStatusCode.BadRequest;
                    response.Message = "This tourament can't not join";
                    return response;
                }
                var amountInt = (int)Math.Round((decimal)touramentData.EntryFee);
                ItemData item = new ItemData("Register for Tourament", tourId, amountInt);
                List<ItemData> items = new List<ItemData> { item };
                string description = $"Fee{registrationId}User{userId}End";
                var userInfo = await _userRepository.GetById(userId);
                PaymentData paymentData = new PaymentData(
                    orderCode,
                    amountInt,
                    description,
                    items,
                    cancel_URL,
                    return_URL,
                    null, // signature
                    null, // buyerName
                    null, // buyerEmail
                    userInfo.PhoneNumber, // buyerPhone --> 🔥 Gán ở đúng vị trí
                    null, // buyerAddress
                    null  // expiredAt
                );
                var paymentResponse = await _payOs.createPaymentLink(paymentData);
                response.Data = paymentResponse.checkoutUrl;
                response.Message = "Successful";
                response.statusCode = HttpStatusCode.OK;
                return response;

            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
        }
        private string TrimDescription(string description, int maxLength = 25)
        {
            if (description.Length <= maxLength)
                return description;
            return description.Substring(0, maxLength);
        }

    }

}
