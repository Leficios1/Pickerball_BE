using Database.DTO.Response;
using Database.Model;
using Repository.Repository.Interfeace;
using Services.Services.Interface;
using System.Net;

namespace Services.Services
{
    public class RuleService : IRuleService
    {
        private readonly IRuleRepository _ruleRepository;
        public RuleService(IRuleRepository blogCategoriesRepository)
        {
            _ruleRepository = blogCategoriesRepository;
        }

        public async Task<StatusResponse<Rule>> CreateRule(Rule Rule)
        {
            StatusResponse<Rule> response = new StatusResponse<Rule>();
            try
            {
                await _ruleRepository.AddAsync(Rule);
                await _ruleRepository.SaveChangesAsync();

                response.Data = Rule;
                response.statusCode = HttpStatusCode.OK;
                response.Message = "Blog Category created successfully!";
            }
            catch (Exception ex)
            {
                response.statusCode = HttpStatusCode.InternalServerError;
                response.Message = ex.Message;
            }
            return response;
        }

        public async Task<StatusResponse<bool>> DeleteRule(int RuleId)
        {
            StatusResponse<bool> response = new StatusResponse<bool>();
            try
            {
                var Rule = await _ruleRepository.GetById(RuleId);
                if (Rule == null)
                {
                    response.statusCode = HttpStatusCode.NotFound;
                    response.Message = "Blog Category not found!";
                }
                else
                {
                    _ruleRepository.Delete(Rule);
                    await _ruleRepository.SaveChangesAsync();

                    response.Data = true;
                    response.statusCode = HttpStatusCode.OK;
                    response.Message = "Blog Category deleted successfully!";
                }
            }
            catch (Exception ex)
            {
                response.statusCode = HttpStatusCode.InternalServerError;
                response.Message = ex.Message;
            }
            return response;
        }

        public async Task<StatusResponse<PagingResult<Rule>>> PaginglRules(int? currentPage, int? pageSize)
        {
            var response = new StatusResponse<PagingResult<Rule>>();
            try
            {
                var blogCategories = await _ruleRepository.PagingRule(currentPage, pageSize);

                response.Data = blogCategories;
                response.statusCode = HttpStatusCode.OK;
                response.Message = "Blog Categories retrieved successfully!";
                return response;
            }
            catch (Exception ex)
            {
                response.statusCode = HttpStatusCode.InternalServerError;
                response.Message = ex.Message;
                return response;
            }
        }

        public async Task<StatusResponse<Rule>> GetRuleById(int RuleId)
        {
            var response = new StatusResponse<Rule>();
            try
            {
                var data = await _ruleRepository.GetById(RuleId);
                if (data == null)
                {
                    response.statusCode = HttpStatusCode.NotFound;
                    response.Message = "Blog Categories not found!";
                    return response;
                }

                response.Data = data;
                response.statusCode = HttpStatusCode.OK;
                response.Message = "Get Blog Categories by id success!";

            }
            catch (Exception e)
            {
                response.statusCode = HttpStatusCode.InternalServerError;
                response.Message = e.Message;
            }
            return response;
        }

        public async Task<StatusResponse<Rule>> UpdateRule(Rule Rule)
        {
            StatusResponse<Rule> response = new StatusResponse<Rule>();
            try
            {
                _ruleRepository.Update(Rule);
                await _ruleRepository.SaveChangesAsync();

                response.Data = Rule;
                response.statusCode = HttpStatusCode.OK;
                response.Message = "Blog Category created successfully!";
            }
            catch (Exception ex)
            {
                response.statusCode = HttpStatusCode.InternalServerError;
                response.Message = ex.Message;
            }
            return response;
        }
    }
}
