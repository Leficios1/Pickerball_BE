using AutoMapper;
using Database.DTO.Request;
using Database.DTO.Response;
using Database.Model;
using Repository.Repository.Interfeace;
using Services.Services.Interface;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;
using System.Transactions;

namespace Services.Services
{
    public class VenuesServices : IVenuesServices
    {
        private readonly IVenusRepository _venuesRepository;
        private readonly IMapper _mapper;

        public VenuesServices(IVenusRepository venuesRepository, IMapper mapper)
        {
            _venuesRepository = venuesRepository;
            _mapper = mapper;
        }

        public async Task<StatusResponse<VenuesResponseDTO>> CreateVenuesAsync(VenuesRequestDTO dto)
        {
            var response = new StatusResponse<VenuesResponseDTO>();
            try
            {
                var venueEntity = _mapper.Map<Venues>(dto);
                await _venuesRepository.AddAsync(venueEntity);
                await _venuesRepository.SaveChangesAsync();
                var data = _mapper.Map<VenuesResponseDTO>(venueEntity);
                response.Data = data;
                response.Message = "Venues created successfully";
                response.statusCode = HttpStatusCode.OK;
            }
            catch (Exception ex)
            {
                response.Message = ex.Message;
                response.statusCode = HttpStatusCode.InternalServerError;
            }
            return response;
        }

        public async Task<StatusResponse<List<VenuesResponseDTO>>> GetAllVenuesAsync()
        {
            var response = new StatusResponse<List<VenuesResponseDTO>>();
            try
            {
                var venues = await _venuesRepository.GetAll();
                response.Data = _mapper.Map<List<VenuesResponseDTO>>(venues);
                response.Message = "Venues fetched successfully";
                response.statusCode = HttpStatusCode.OK;
            }
            catch (Exception ex)
            {
                response.Message = ex.Message;
                response.statusCode = HttpStatusCode.InternalServerError;
            }
            return response;
        }

        public async Task<StatusResponse<VenuesResponseDTO>> GetVenuesAsync(int id)
        {
            var response = new StatusResponse<VenuesResponseDTO>();
            try
            {
                var data = await _venuesRepository.GetById(id);
                response.Data = _mapper.Map<VenuesResponseDTO>(data);
                response.Message = "Venues fetched successfully";
                response.statusCode = HttpStatusCode.OK;
            }
            catch (Exception ex)
            {
                response.Message = ex.Message;
                response.statusCode = HttpStatusCode.InternalServerError;
            }

            return response;
        }

        public async Task<StatusResponse<List<VenuesResponseDTO>>> GetVenuesSponner(int id)
        {
            var response = new StatusResponse<List<VenuesResponseDTO>>();
            try
            {
                var data = await _venuesRepository.GetVenuesByCreateByAsync(id);
                response.Data = _mapper.Map<List<VenuesResponseDTO>>(data);
                response.Message = "Venues fetched successfully";
                response.statusCode = HttpStatusCode.OK;
            }
            catch (Exception ex)
            {
                response.Message = ex.Message;
                response.statusCode = HttpStatusCode.InternalServerError;
            }

            return response;
        }
        
        public async Task<StatusResponse<VenuesResponseDTO>> UpdateVenuesAsync(int id, VenuesRequestDTO dto)
        {
            var response = new StatusResponse<VenuesResponseDTO>();
        
            using (var transaction = new TransactionScope(TransactionScopeAsyncFlowOption.Enabled))
            {
                try
                {
                    var existingVenue = await _venuesRepository.GetById(id);
                    if (existingVenue == null)
                    {
                        return new StatusResponse<VenuesResponseDTO>
                        {
                            Message = "Venue not found",
                            statusCode = HttpStatusCode.NotFound
                        };
                    }
        
                    // Apply the values from VenuesRequestDTO
                    foreach (var property in typeof(VenuesRequestDTO).GetProperties())
                    {
                        var value = property.GetValue(dto);
                        if (value != null)
                        {
                            var existingProperty = typeof(Venues).GetProperty(property.Name);
                            if (existingProperty != null)
                            {
                                existingProperty.SetValue(existingVenue, value);
                            }
                        }
                    }
        
                    _venuesRepository.Update(existingVenue);
                    await _venuesRepository.SaveChangesAsync();
        
                    response.Data = _mapper.Map<VenuesResponseDTO>(existingVenue);
                    response.statusCode = HttpStatusCode.OK;
                    response.Message = "Venue Updated Successfully";
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
    }
}
