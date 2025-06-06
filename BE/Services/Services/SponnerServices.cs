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
        private readonly IUserRepository _userRepository;
        private readonly IPlayerRepository _playerRepository;
        private readonly IMapper _mapper;
        public SponnerServices(ISponsorRepository sponsorRepository, IMapper mapper, IUserRepository userRepository, IPlayerRepository playerRepository)
        {
            _sponsorRepository = sponsorRepository;
            _mapper = mapper;
            _userRepository = userRepository;
            _playerRepository = playerRepository;
        }

        public async Task<StatusResponse<bool>> AccpetSponner(int SponnerId, bool isAccept)
        {
            var response = new StatusResponse<bool>();
            try
            {
                var data = (await _sponsorRepository.Find(x => x.SponsorId == SponnerId)).FirstOrDefault();
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
                if (dto == null || dto.Id == null)
                {
                    response.Message = "Invalid Sponner data";
                    response.statusCode = HttpStatusCode.BadRequest;
                    return response;
                }
                var flag = await _playerRepository.GetPlayerById((int)dto.Id);
                if(flag != null)
                {
                    response.Message = "User is already a player";
                    response.statusCode = HttpStatusCode.BadRequest;
                    return response;
                }
                var data = _mapper.Map<Sponsor>(dto);
                data.SponsorId = (int)dto.Id;
                data.isAccept = false;
                data.JoinedAt = DateTime.UtcNow;
                var user = await _userRepository.GetById(dto.Id);
                if (user == null)
                {
                    response.Message = "User not found";
                    response.statusCode = HttpStatusCode.NotFound;
                    return response;
                }
                user.RoleId = 3;
                await _sponsorRepository.AddAsync(data);
                _userRepository.Update(user);
                await _userRepository.SaveChangesAsync();
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
                var data = (await _sponsorRepository.Find(s => s.SponsorId == SponnerId)).FirstOrDefault();
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
        
        public async Task<StatusResponse<SponnerResponseDTO>> UpdateSponner(SponnerUpdateRequestDTO dto, int id)
        {
            var response = new StatusResponse<SponnerResponseDTO>();
            try
            {
                var data = await _sponsorRepository.GetById(id);
                if (data == null)
                {
                    response.Message = "Sponner not found";
                    response.statusCode = HttpStatusCode.NotFound;
                    return response;
                }

                // Apply the values from SponnerUpdateRequestDTO
                foreach (var property in typeof(SponnerUpdateRequestDTO).GetProperties())
                {
                    var value = property.GetValue(dto);
                    if (value != null)
                    {
                        var existingProperty = typeof(Sponsor).GetProperty(property.Name);
                        if (existingProperty != null)
                        {
                            existingProperty.SetValue(data, value);
                        }
                    }
                }

                _sponsorRepository.Update(data);
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
