using Database.Model;
using Microsoft.AspNetCore.Mvc;
using Services.Services.Interface;

namespace PickerBall_BE.Controllers
{
    [Route("api/rules")]
    [ApiController]
    public class RulesController : ControllerBase
    {
        private readonly IRuleService _ruleService;
        public RulesController(IRuleService Rule)
        {
            _ruleService = Rule;
        }
        [HttpGet]
        public async Task<IActionResult> PagingRules(int? currentPage, int? pageSize)
        {
            var response = await _ruleService.PaginglRules(currentPage, pageSize);
            return StatusCode((int)response.statusCode, new { data = response.Data, message = response.Message });
        }
        [HttpGet("get-by-id")]
        public async Task<IActionResult> GetRuleById(int RuleId)
        {
            var response = await _ruleService.GetRuleById(RuleId);
            return StatusCode((int)response.statusCode, new { data = response.Data, message = response.Message });
        }
        [HttpPost("create")]
        public async Task<IActionResult> CreateRule(Rule Rule)
        {
            var response = await _ruleService.CreateRule(Rule);
            return StatusCode((int)response.statusCode, new { data = response.Data, message = response.Message });
        }
        [HttpPut("edit")]
        public async Task<IActionResult> UpdateRule(Rule Rule)
        {
            var response = await _ruleService.UpdateRule(Rule);
            return StatusCode((int)response.statusCode, new { data = response.Data, message = response.Message });
        }
        [HttpDelete("delete")]
        public async Task<IActionResult> DeleteRule(int RuleId)
        {
            var response = await _ruleService.DeleteRule(RuleId);
            return StatusCode((int)response.statusCode, new { data = response.Data, message = response.Message });
        }
    }
}