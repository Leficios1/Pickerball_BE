using Database.DTO.Request;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Services.Services.Interface;

namespace PickerBall_BE.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class VenuesController : ControllerBase
    {
        private readonly IVenuesServices _venuesServices;

        public VenuesController(IVenuesServices venuesServices)
        {
            _venuesServices = venuesServices;
        }

        [HttpGet("GetAllVenues")]
        public async Task<IActionResult> GetAllVenues()
        {
            var response = await _venuesServices.GetAllVenuesAsync();
            return StatusCode((int)response.statusCode, new { data = response.Data, message = response.Message });
        }

        [HttpGet("GetVenues/{id}")]
        public async Task<IActionResult> GetVenues([FromRoute] int id)
        {
            var response = await _venuesServices.GetVenuesAsync(id);
            return StatusCode((int)response.statusCode, new { data = response.Data, message = response.Message });
        }
        [HttpGet("GetVenueSponner/{id}")]
        public async Task<IActionResult> GetVenueSponner([FromRoute] int id)
        {
            var response = await _venuesServices.GetVenuesSponner(id);
            return StatusCode((int)response.statusCode, new { data = response.Data, message = response.Message });
        }

        [HttpPost("CreateVenues")]
        public async Task<IActionResult> CreateVenues([FromBody] VenuesRequestDTO venuesRequestDTO)
        {
            var response = await _venuesServices.CreateVenuesAsync(venuesRequestDTO);
            return StatusCode((int)response.statusCode, new { data = response.Data, message = response.Message });
        }
        
        [HttpPatch("UpdateVenues/{id}")]
        public async Task<IActionResult> UpdateVenues([FromRoute] int id, [FromBody] VenuesRequestDTO venuesRequestDTO)
        {
            var response = await _venuesServices.UpdateVenuesAsync(id, venuesRequestDTO);
            return StatusCode((int)response.statusCode, new { data = response.Data, message = response.Message });
        }
    }
}
