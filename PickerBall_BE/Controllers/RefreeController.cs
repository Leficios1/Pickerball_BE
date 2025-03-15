using Microsoft.AspNetCore.Mvc;
using System.Threading.Tasks;
using Database.DTO.Request;
using Database.DTO.Response;
using Services.Services.Interface;
using System.Collections.Generic;
using Database.Model;

namespace PickerBall_BE.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class RefreeController : ControllerBase
    {
        private readonly IReFeeSevice _refreeService;

        public RefreeController(IReFeeSevice refreeService)
        {
            _refreeService = refreeService;
        }

        [HttpPatch("{id}")]
        public async Task<IActionResult> UpdateRefree(int id, [FromBody] UpdateRefreeDTO dto)
        {
            var response = await _refreeService.UpdateRefree(dto, id);
            return StatusCode((int)response.statusCode, response);
        }

        [HttpGet("code/{refreeCode}")]
        public async Task<IActionResult> GetByRefreeCode(string refreeCode)
        {
            var referees = await _refreeService.GetByRefreeCode(refreeCode);
            return Ok(referees);
        }

        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            var referees = await _refreeService.GetAll();
            return Ok(referees);
        }
    }
}
