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
                await _venuesRepository.AddAsync(_mapper.Map<Venues>(dto));
                await _venuesRepository.SaveChangesAsync();
                var data = _mapper.Map<VenuesResponseDTO>(dto);
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
    }
}
