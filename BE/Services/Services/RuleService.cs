using AutoMapper;
using Database.DTO.Request;
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
        private readonly IMapper _mapper;
        public RuleService(IRuleRepository rulesRepository, IMapper mapper)
        {
            _ruleRepository = rulesRepository;
            _mapper = mapper;
        }

        public async Task<StatusResponse<RuleResponseDTO>> CreateRule(RuleCreateDTO Rule)
        {
            StatusResponse<RuleResponseDTO> response = new StatusResponse<RuleResponseDTO>();
            try
            {
                var rule = _mapper.Map<Rule>(Rule);
                await _ruleRepository.AddAsync(rule);
                await _ruleRepository.SaveChangesAsync();

                response.Data = _mapper.Map<RuleResponseDTO>(rule);
                response.statusCode = HttpStatusCode.OK;
                response.Message = "Rule created successfully!";
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
                    response.Message = "Rule not found!";
                }
                else
                {
                    _ruleRepository.Delete(Rule);
                    await _ruleRepository.SaveChangesAsync();

                    response.Data = true;
                    response.statusCode = HttpStatusCode.OK;
                    response.Message = "Rule deleted successfully!";
                }
            }
            catch (Exception ex)
            {
                response.statusCode = HttpStatusCode.InternalServerError;
                response.Message = ex.Message;
            }
            return response;
        }

        public async Task<StatusResponse<PagingResult<RuleResponseDTO>>> PaginglRules(int? currentPage, int? pageSize)
        {
            var response = new StatusResponse<PagingResult<RuleResponseDTO>>();
            try
            {
                var rules = await _ruleRepository.PagingRule(currentPage, pageSize);

                response.Data = _mapper.Map<PagingResult<RuleResponseDTO>>(rules);
                response.statusCode = HttpStatusCode.OK;
                response.Message = "Rules retrieved successfully!";
                return response;
            }
            catch (Exception ex)
            {
                response.statusCode = HttpStatusCode.InternalServerError;
                response.Message = ex.Message;
                return response;
            }
        }

        public async Task<StatusResponse<RuleResponseDTO>> GetRuleById(int RuleId)
        {
            var response = new StatusResponse<RuleResponseDTO>();
            try
            {
                var data = await _ruleRepository.GetById(RuleId);
                if (data == null)
                {
                    response.statusCode = HttpStatusCode.NotFound;
                    response.Message = "Rules not found!";
                    return response;
                }

                response.Data = _mapper.Map<RuleResponseDTO>(data);
                response.statusCode = HttpStatusCode.OK;
                response.Message = "Get Rules by id success!";

            }
            catch (Exception e)
            {
                response.statusCode = HttpStatusCode.InternalServerError;
                response.Message = e.Message;
            }
            return response;
        }

        public async Task<StatusResponse<RuleResponseDTO>> UpdateRule(RuleUpdateDTO dto)
        {
            StatusResponse<RuleResponseDTO> response = new StatusResponse<RuleResponseDTO>();
            try
            {
                var rule = await _ruleRepository.GetById(dto.Id);
                _mapper.Map(dto, rule);
                _ruleRepository.Update(rule);
                await _ruleRepository.SaveChangesAsync();

                response.Data = _mapper.Map<RuleResponseDTO>(rule);
                response.statusCode = HttpStatusCode.OK;
                response.Message = "Rule created successfully!";
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
