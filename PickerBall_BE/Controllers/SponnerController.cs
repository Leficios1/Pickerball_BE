using Database.DTO.Request;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Services.Services;
using Services.Services.Interface;

namespace PickerBall_BE.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class SponnerController : ControllerBase
    {
        private readonly ISponnerServices _sponnerServices;
        public SponnerController(ISponnerServices sponnerServices)
        {
            _sponnerServices = sponnerServices;
        }
        [HttpGet("GetById/{SponnerId}")]
        public async Task<IActionResult> GetById([FromRoute] int SponnerId)
        {
            var response = await _sponnerServices.getSponnerById(SponnerId);
            return StatusCode((int)response.statusCode, response);
        }
        [HttpGet("AcceptSponse/{SponnerId}")]
        public async Task<IActionResult> AcceptSponser([FromRoute] int SponnerId)
        {
            var response = await _sponnerServices.AccpetSponner(SponnerId);
            return StatusCode((int)response.statusCode, response);
        }
        [HttpPost("CreateSponner")]
        public async Task<IActionResult> CreateSponner([FromBody] SponnerRequestDTO dto)
        {
            var response = await _sponnerServices.CreateSponner(dto);
            return StatusCode((int)response.statusCode, response);
        }
        [HttpPut("UpdateSponner")]
        public async Task<IActionResult> UpdateSponner([FromBody] SponnerRequestDTO dto)
        {
            var response = await _sponnerServices.UpdateSponner(dto);
            return StatusCode((int)response.statusCode, response);
        }
    }
}
