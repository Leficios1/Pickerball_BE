using Database.DTO.Request;
using Database.DTO.Response;
using Database.Model;

namespace Services.Services.Interface
{
    public interface IRuleService
    {
        public Task<StatusResponse<PagingResult<RuleResponseDTO>>> PaginglRules(int? currentPage, int? pageSize);
        public Task<StatusResponse<RuleResponseDTO>> GetRuleById(int ruleId);
        public Task<StatusResponse<RuleResponseDTO>> UpdateRule(RuleUpdateDTO Rule);
        public Task<StatusResponse<RuleResponseDTO>> CreateRule(RuleCreateDTO Rule);
        public Task<StatusResponse<bool>> DeleteRule(int ruleId);
    }
}
