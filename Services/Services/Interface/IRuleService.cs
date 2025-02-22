using Database.DTO.Response;
using Database.Model;

namespace Services.Services.Interface
{
    public interface IRuleService
    {
        public Task<StatusResponse<PagingResult<Rule>>> PaginglRules(int? currentPage, int? pageSize);
        public Task<StatusResponse<Rule>> GetRuleById(int ruleId);
        public Task<StatusResponse<Rule>> UpdateRule(Rule Rule);
        public Task<StatusResponse<Rule>> CreateRule(Rule Rule);
        public Task<StatusResponse<bool>> DeleteRule(int ruleId);
    }
}
