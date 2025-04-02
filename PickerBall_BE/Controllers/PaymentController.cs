using Database.DTO.Request;
using Database.Helper;
using Database.Model;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Services.Services;
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

        [HttpGet("vn-pay/{userId}/{WhoAreYou}/{registrationId}")]
        public async Task<IActionResult> PayWithUserId([FromRoute] int userId, [FromRoute] int WhoAreYou, [FromRoute] int registrationId)
        {
            var result = await _vpnpayService.CallApiByUserId(userId, WhoAreYou, registrationId, null, null );
            return Ok(result);
        }
        [HttpGet("vn-pay/GetAll")]
        public async Task<IActionResult> GetAll()
        {
            var result = await _vpnpayService.GetAll();
            return Ok(result);
        }
        [HttpGet("vn-pay/GetAllBillByTouramentId/{TouramentId}")]
        public async Task<IActionResult> GetAllBillByTouramentId([FromRoute] int TouramentId)
        {
            var result = await _vpnpayService.GetAllBillByTourament(TouramentId);
            return Ok(result);
        }
        [HttpGet("vn-pay/GetAllBillBySponnerId/{SponnerId}")]
        public async Task<IActionResult> GetAllBillBySponnerId([FromRoute] int SponnerId)
        {
            var result = await _vpnpayService.GetAllBillBySponnerId(SponnerId);
            return Ok(result);
        }
        [HttpGet("vn-pay/GetById/{BillId}")]
        public async Task<IActionResult> GetById([FromRoute] int BillId)
        {
            var result = await _vpnpayService.GetBillById(BillId);
            return Ok(result);
        }
        [HttpPost("vn-pay/check-payment")]
        public async Task<IActionResult> Check(VnpayRequestDTO dto)
        {
            var result = await _vpnpayService.GetVnpayPaymentUrl(dto);
            return Ok(result);
        }

        //[HttpPost]
        //[Route("vnpay/pay")]
        //public async Task<IActionResult> CreatePayment([FromBody] VnpayRequestDTO paymentRequest)
        //{
        //    //tạo ui gồm các kiểu thanh toán dưới đây
        //    //type bao gồm qrcode, ngân hàng nội địa, thẻ quốc tế
        //    var response = await _vpnpayService.GetVnpayPaymentUrl(paymentRequest);
        //    return StatusCode((int)response.statusCode, new { data = response.Data, message = response.Message });
        //}
    }
}
