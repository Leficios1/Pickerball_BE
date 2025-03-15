using Database.Model;
using Repository.Repository.Interface;
using Services.Services.Interface;
using System.Collections.Generic;
using System.Net;
using System.Threading.Tasks;
using System.Transactions;
using AutoMapper;
using Database.DTO.Request;
using Database.DTO.Response;

namespace Services.Services
{
    public class ReFeeSevice : IReFeeSevice
    {
        private readonly IRefreeRepository _refreeRepository;
        private readonly IMapper _mapper;
        
        public ReFeeSevice(IRefreeRepository refreeRepository)
        {
            _refreeRepository = refreeRepository;
        }

        public async Task<Refree> CreateRefreeAsync(CreateRefreeDTO refreeDto)
        {
           return await _refreeRepository.CreateRefreeAsync(refreeDto);
        }

        public async Task<StatusResponse<Refree>> UpdateRefree(UpdateRefreeDTO dto, int id)
        {
            var response = new StatusResponse<Refree>();

            using (var transaction = new TransactionScope(TransactionScopeAsyncFlowOption.Enabled))
            {
                try
                {
                    var existingRefree = await _refreeRepository.GetById(id);
                    if (existingRefree == null)
                    {
                        return new StatusResponse<Refree>
                        {
                            Message = "Refree not found",
                            statusCode = HttpStatusCode.NotFound
                        };
                    }

                    // Apply the values from UpdateRefreeDTO
                    foreach (var property in typeof(UpdateRefreeDTO).GetProperties())
                    {
                        var value = property.GetValue(dto);
                        if (value != null)
                        {
                            var existingProperty = typeof(Refree).GetProperty(property.Name);
                            if (existingProperty != null)
                            {
                                existingProperty.SetValue(existingRefree, value);
                            }
                        }
                    }

                    _refreeRepository.Update(existingRefree);
                    await _refreeRepository.SaveChangesAsync();

                    response.Data = existingRefree;
                    response.statusCode = HttpStatusCode.OK;
                    response.Message = "Refree Updated Successfully";
                    transaction.Complete();
                }
                catch (Exception ex)
                {
                    response.Message = ex.Message;
                    response.statusCode = HttpStatusCode.InternalServerError;
                }
            }

            return response;
        }
        
        public async Task<List<Refree>> GetByRefreeCode(string id)
        {
            return await _refreeRepository.GetByRefreeCode(id);
        }

        public async Task<List<Refree>> GetAll()
        {
            return await _refreeRepository.GetAllRefreesAsync();
        }
    }
}
