using AutoMapper;
using Database.DTO.Response;
using Microsoft.EntityFrameworkCore;
using Repository.Repository.Interfeace;
using Services.Services.Interface;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Services.Services
{
    public class AchivementServices : IAchivementServices
    {
        private readonly IAchivementRepository _achivementRepository;
        private readonly IMapper _mapper;

        public AchivementServices(IAchivementRepository achivementRepository, IMapper mapper)
        {
            _achivementRepository = achivementRepository;
            _mapper = mapper;
        }

        public async Task<StatusResponse<List<AchivementResponseDTO>>> GetAchivementByUserId(int userId)
        {
            var response = new StatusResponse<List<AchivementResponseDTO>>();
            try
            {
                var dataAchivement = await _achivementRepository.Get().Where(x => x.UserId == userId).ToListAsync();
                if (dataAchivement == null)
                {
                    response.Data = null;
                    response.statusCode = System.Net.HttpStatusCode.OK;
                    response.Message = "Get Successfull";
                }
                else
                {
                    var result = _mapper.Map<List<AchivementResponseDTO>>(dataAchivement);
                    response.Data = result;
                    response.statusCode = System.Net.HttpStatusCode.OK;
                    response.Message = "Get Successfull";
                }
            }
            catch (Exception ex)
            {
                response.statusCode=System.Net.HttpStatusCode.InternalServerError;
                response.Message = ex.Message;
            }
            return response;
        }
    }
}
