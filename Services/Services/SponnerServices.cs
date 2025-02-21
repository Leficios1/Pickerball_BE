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
    public class SponnerServices : ISponnerServices
    {
        private readonly ISponsorRepository _sponsorRepository;
        private readonly IMapper _mapper;
        public SponnerServices(ISponsorRepository sponsorRepository, IMapper mapper)
        {
            _sponsorRepository = sponsorRepository;
            _mapper = mapper;
        }

        public async Task<StatusResponse<bool>> AccpetSponner(int SponnerId, bool isAccept)
        {
            var response = new StatusResponse<bool>();
            try
            {
                var data = await _sponsorRepository.GetById(SponnerId);
                if (data == null)
                {
                    response.Message = "Sponner not found";
                    response.statusCode = HttpStatusCode.NotFound;
                    return response;
                }
                data.isAccept = isAccept;
                _sponsorRepository.Update(data);
                await _sponsorRepository.SaveChangesAsync();
                response.Data = true;
                response.statusCode = HttpStatusCode.OK;
                response.Message = isAccept ? "Sponner Accepted Successfully" : "Sponner Rejected Successfully";
            }
            catch (Exception ex)
            {
                response.Message = ex.Message;
                response.statusCode = HttpStatusCode.InternalServerError;
            }
            return response;
        }
        
        public async Task<StatusResponse<List<SponnerResponseDTO>>> getAllSponner()
        {
            var response = new StatusResponse<List<SponnerResponseDTO>>();
            try
            {
                var data = await _sponsorRepository.GetAllSponsorsOrderedByCreateAtAsync();
                response.Data = _mapper.Map<List<SponnerResponseDTO>>(data);
                response.statusCode = HttpStatusCode.OK;
                response.Message = "Get All Sponsors Successfully";
            }
            catch (Exception ex)
            {
                response.Message = ex.Message;
                response.statusCode = HttpStatusCode.InternalServerError;
            }
            return response;
        }

        public async Task<StatusResponse<SponnerResponseDTO>> CreateSponner(SponnerRequestDTO dto)
        {
            var response = new StatusResponse<SponnerResponseDTO>();
            try
            {
                var data = _mapper.Map<Sponsor>(dto);
                data.isAccept = false;
                data.JoinedAt = DateTime.UtcNow;
                await _sponsorRepository.AddAsync(data);
                await _sponsorRepository.SaveChangesAsync();
                response.Data = _mapper.Map<SponnerResponseDTO>(data);
                response.statusCode = HttpStatusCode.OK;
                response.Message = "Sponner Created Successfully";
            }
            catch (Exception ex)
            {
                response.Message = ex.Message;
                response.statusCode = HttpStatusCode.InternalServerError;
            }

            return response;
        }

        public async Task<StatusResponse<SponnerResponseDTO>> getSponnerById(int SponnerId)
        {
            var response = new StatusResponse<SponnerResponseDTO>();
            try
            {
                var data = (await _sponsorRepository.Find(s => s.SponsorId == SponnerId, orderBy: q => q.OrderByDescending(s => s.JoinedAt))).FirstOrDefault();
                if (data == null)
                {
                    response.Message = "Sponner not found";
                    response.statusCode = HttpStatusCode.NotFound;
                    return response;
                }
                response.Data = _mapper.Map<SponnerResponseDTO>(data);
                response.statusCode = HttpStatusCode.OK;
                response.Message = "Sponner Found Successfully";
            }
            catch (Exception ex)
            {
                response.Message = ex.Message;
                response.statusCode = HttpStatusCode.InternalServerError;
            }
            return response;
        }

        public async Task<StatusResponse<SponnerResponseDTO>> UpdateSponner(SponnerRequestDTO dto)
        {
            var response = new StatusResponse<SponnerResponseDTO>();
            try
            {
                var data = await _sponsorRepository.GetById(dto.Id);
                if (data == null)
                {
                    response.Message = "Sponner not found";
                    response.statusCode = HttpStatusCode.NotFound;
                    return response;
                }
                _sponsorRepository.Update(_mapper.Map(dto, data));
                await _sponsorRepository.SaveChangesAsync();
                response.Data = _mapper.Map<SponnerResponseDTO>(data);
                response.statusCode = HttpStatusCode.OK;
                response.Message = "Sponner Updated Successfully";
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
