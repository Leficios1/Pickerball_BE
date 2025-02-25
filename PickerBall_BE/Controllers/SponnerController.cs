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

        [HttpGet("GetAll")]
        public async Task<IActionResult> GeAll()
        {
            var response = await _sponnerServices.getAllSponner();
            return StatusCode((int)response.statusCode, response);
        }
        
        [HttpPost("AcceptSponser")]
        public async Task<IActionResult> AcceptSponser([FromBody] AcceptSponserRequestDTO request)
        {
            var response = await _sponnerServices.AccpetSponner(request.SponnerId, request.IsAccept);
            return StatusCode((int)response.statusCode, response);
        }
        
        [HttpPost("CreateSponner")]
        public async Task<IActionResult> CreateSponner([FromBody] SponnerRequestDTO dto)
        {
            var response = await _sponnerServices.CreateSponner(dto);
            return StatusCode((int)response.statusCode, response);
        }
        [HttpPatch("UpdateSponner/{id}")]
        public async Task<IActionResult> UpdateSponner([FromRoute] int id, [FromBody] SponnerUpdateRequestDTO dto)
        {
            var response = await _sponnerServices.UpdateSponner(dto, id);
            return StatusCode((int)response.statusCode, response);
        }
    }
}
