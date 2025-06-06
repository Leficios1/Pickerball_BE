using Azure;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.Tokens;
using Services.Services.Interface;

namespace PickerBall_BE.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class PayOsController : ControllerBase
    {
        private readonly IPayOsServices _services;

        public PayOsController(IPayOsServices services)
        {
            _services = services;
        }

        [HttpGet("GetPaymentUrl")]
        public async Task<IActionResult> CheckoutForSponner(int userId, int tourId, decimal Amount, int linkReturn)
        {
            var response = await _services.CheckoutForSponner(userId, tourId, Amount, linkReturn);
            return StatusCode((int)response.statusCode, new { data = response.Data, message = response.Message });
        }

        [HttpGet("GetPaymentForPlayerUrl")]
        public async Task<IActionResult> GetPaymentForPlayerUrl(int userId, int tourId, int linkReturn, int registrationId)
        {
            var response = await _services.PaymentForPlayer(userId, tourId, linkReturn, registrationId);
            return StatusCode((int)response.statusCode, new { data = response.Data, message = response.Message });
        }

        [HttpGet("Payment-Return")]
        public async Task<IActionResult> PaymentReturn([FromQuery] long orderCode)
        {

            var response = await _services.getPaymentInfo(orderCode);
            return StatusCode((int)response.statusCode, new { data = response.Data, message = response.Message });
        }

    }
}
