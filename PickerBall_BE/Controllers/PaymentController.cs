using Database.DTO.Request;
using Database.Helper;
using Database.Model;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Services.Services.Interface;

namespace PickerBall_BE.Controllers
{
    [Route("api/payment")]
    [ApiController]
    public class PaymentController : ControllerBase
    {
        private readonly IVnpayService _vpnpayService;
        public PaymentController(IVnpayService vpnpayService)
        {
            _vpnpayService = vpnpayService;
        }

        [HttpPost]
        [Route("vnpay/pay")]
        public async Task<IActionResult> CreatePayment([FromBody] VnpayRequestDTO paymentRequest)
        {
            //tạo ui gồm các kiểu thanh toán dưới đây
            //type bao gồm qrcode, ngân hàng nội địa, thẻ quốc tế
            var response = await _vpnpayService.GetVnpayPaymentUrl(paymentRequest);
            return StatusCode((int)response.statusCode, new { data = response.Data, message = response.Message });
        }
    }
}
