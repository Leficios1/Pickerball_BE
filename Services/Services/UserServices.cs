using AutoMapper;
using Database.DTO.Request;
using Database.DTO.Response;
using Database.Model;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Repository.Repository.Interfeace;
using Services.Services.Interface;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Numerics;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;
using System.Transactions;
using Repository.Repository.Interface;

namespace Services.Services
{
    public class UserServices : IUserServices
    {
        private readonly IUserRepository _userRepository;
        private readonly IPlayerRepository _playerRepository;
        private readonly ISponsorRepository _sponsorRepository;
        private readonly IRefreeRepository _refreeRepository;
        private readonly IMapper _mapper;
        
        public UserServices(IUserRepository userRepository, IMapper mapper, IPlayerRepository playerRepository,IRefreeRepository refreeRepository, ISponsorRepository sponsorRepository)
        {
            _userRepository = userRepository;
            _mapper = mapper;
            _playerRepository = playerRepository;
            _sponsorRepository = sponsorRepository;
            _refreeRepository = refreeRepository;
        }

        public async Task<StatusResponse<bool>> AcceptUser(int sponserId)
        {
            var response = new StatusResponse<bool>();
            try
            {
                var sponsor = await _sponsorRepository.GetById(sponserId);
                if (sponsor == null)
                {
                    response.statusCode = HttpStatusCode.NotFound;
                    response.Message = "Sponsor not found!";
                    return response;
                }
                sponsor.isAccept = true;
                await _sponsorRepository.SaveChangesAsync();
                response.Data = true;
                response.statusCode = HttpStatusCode.OK;
                response.Message = "Accept sponsor success!";
            }
            catch (Exception e)
            {
                response.statusCode = HttpStatusCode.InternalServerError;
                response.Message = e.Message;
            }
            return response;
        }

        public async Task<StatusResponse<bool>> DeletedUser(int UserId)
        {
            var response = new StatusResponse<bool>();
            try
            {
                var user = await _userRepository.GetUserByIdAsync(UserId);
                if (user == null)
                {
                    response.statusCode = HttpStatusCode.NotFound;
                    response.Message = "User not found!";
                    return response;
                }
                var playerInfo =await _playerRepository.GetPlayerById(UserId);
                var sponsorInfo = await _sponsorRepository.GetById(UserId);
                if (playerInfo == null && sponsorInfo == null)
                {
                    _userRepository.Delete(user);
                    await _userRepository.SaveChangesAsync();
                    response.Message = "Delete user success!";

                }
                else
                {
                    user.Status = false;
                    await _userRepository.SaveChangesAsync();
                    response.Message = "User account has been deactivated.";

                }
                response.statusCode = HttpStatusCode.OK;
            }
            catch (Exception e)
            {
                response.statusCode = HttpStatusCode.InternalServerError;
                response.Message = e.Message;
            }
            return response;
        }

        public async Task<StatusResponse<List<Refree>>> getAllRefeeUser()
        {
            var response = new StatusResponse<List<Refree>>();
            try
            {
                var data = await _userRepository.GetAllRefeeUserAsync();
                response.Data = data;
                response.statusCode = HttpStatusCode.OK;
                response.Message = "Get all refee user success!";
            }
            catch (Exception e)
            {
                response.statusCode = HttpStatusCode.InternalServerError;
                response.Message = e.Message;
            }
            return response;
        }

        public async Task<StatusResponse<List<UserResponseDTO>>> getAllUser(int? PageNumber, int? Pagesize, bool isOrderbyCreateAt)
        {
            var response = new StatusResponse<List<UserResponseDTO>>();
            try
            {
                var data = await _userRepository.GetAllUser();
                var TotalItem = data.Count();

                if (isOrderbyCreateAt == true)
                {
                    data = data.OrderByDescending(x => x.CreateAt).ToList();
                }
                int? TotalPage = null;

                if (PageNumber.HasValue || Pagesize.HasValue)
                {
                    Pagesize ??= 10;
                    PageNumber ??= 1;
                    data = data
                        .Skip((PageNumber.Value - 1) * Pagesize.Value)
                        .Take(Pagesize.Value)
                        .ToList();

                    TotalPage = (int)Math.Ceiling((double)TotalItem / Pagesize.Value);
                }
                response.Data = _mapper.Map<List<UserResponseDTO>>(data);
                response.statusCode = HttpStatusCode.OK;
                response.Message = "Get all user success!";
                response.TotalItems = TotalItem;
                response.TotalPages = TotalPage;
            }
            catch (Exception e)
            {
                response.statusCode = HttpStatusCode.InternalServerError;
                response.Message = e.Message;
            }
            return response;
        }

        public async Task<StatusResponse<UserResponseDTO>> getUserById(int UserId)
        {
            var response = new StatusResponse<UserResponseDTO>();
            try
            {
                var data = await _userRepository.GetUserByIdAsync(UserId);
                if (data == null)
                {
                    response.statusCode = HttpStatusCode.NotFound;
                    response.Message = "User not found!";
                    return response;
                }
                var dataPlayerDetails = await _playerRepository.GetPlayerById(UserId);
                var dataSponsorDetails = await _sponsorRepository.GetById(UserId);
                if (dataPlayerDetails != null)
                {
                    response.Data = new UserResponseDTO
                    {
                        //RefreshToken = data.RefreshToken,
                        //RefreshTokenExpiryTime = data.RefreshTokenExpiryTime,
                        Id = data.Id,
                        FirstName = data.FirstName,
                        LastName = data.LastName,
                        SecondName = data.SecondName,
                        Email = data.Email,
                    };
                    response.Data = _mapper.Map<UserResponseDTO>(data);
                    response.Data.userDetails = _mapper.Map<PlayerDetails>(dataPlayerDetails);
                }
                else if (dataSponsorDetails != null)
                {
                    response.Data = _mapper.Map<UserResponseDTO>(data);
                    response.Data.sponsorDetails = _mapper.Map<SponsorDetails>(dataSponsorDetails);
                    response.Data.sponsorDetails.UrlSocial1 = dataSponsorDetails.UrlSocial1;
                    response.Data.sponsorDetails.UrlSocial = dataSponsorDetails.UrlSocial;
                    response.Data.sponsorDetails.isAccept = dataSponsorDetails.isAccept;
                }
                else
                {
                    response.Data = _mapper.Map<UserResponseDTO>(data);
                }
                response.statusCode = HttpStatusCode.OK;
                response.Message = "Get user by id success!";

            }
            catch (Exception e)
            {
                response.statusCode = HttpStatusCode.InternalServerError;
                response.Message = e.Message;
            }
            return response;
        }

        public async Task<StatusResponse<UserResponseDTO>> UpdateUser(UserUpdateRequestDTO dto, int id)
        {
            var response = new StatusResponse<UserResponseDTO>();
            using (var transaction = new TransactionScope(TransactionScopeAsyncFlowOption.Enabled))
                try
                {
                    var existingUser = await _userRepository.GetUserByIdAsync(id);
                    if (existingUser == null)
                    {
                        response.statusCode = HttpStatusCode.NotFound;
                        response.Message = "User not found!";
                        return response;
                    }
                    _mapper.Map(dto, existingUser);
                    response.Data = _mapper.Map<UserResponseDTO>(existingUser);

                    await _userRepository.SaveChangesAsync();
                    response.statusCode = HttpStatusCode.OK;
                    response.Message = "Update user success!";
                    transaction.Complete();
                }
                catch (Exception e)
                {
                    transaction.Dispose();
                    response.statusCode = HttpStatusCode.InternalServerError;
                    response.Message = e.Message;
                }
            return response;
        }
        
        public async Task<StatusResponse<Refree>> CreateReferee(RefereeCreateRequestDTO dto)
        {
            var response = new StatusResponse<Refree>();
            using (var transaction = new TransactionScope(TransactionScopeAsyncFlowOption.Enabled))
                try
                {
                    User user = _mapper.Map<User>(dto);
                    user.PasswordHash = new PasswordHasher<User>().HashPassword(user, dto.Password);
                    user.RefreshToken = GenerateRefreshToken();
                    user.RefreshTokenExpiryTime = DateTime.UtcNow.AddDays(7);

                    await _userRepository.AddAsync(user);
                    await _userRepository.SaveChangesAsync();

                    var createdUser = await _userRepository.GetByEmailAsync(user.Email);
                    if (createdUser == null)
                    {
                        throw new Exception("User not found after creation.");
                    }

                    var referee = new Refree
                    {
                        RefreeId = createdUser.Id,
                        RefreeCode = dto.refereeCode,
                        CreatedAt = DateTime.UtcNow,
                        LastUpdatedAt = DateTime.UtcNow
                    };

                    await _refreeRepository.AddAsync(referee);
                    await _refreeRepository.SaveChangesAsync();

                    var createdReferee = await _refreeRepository.GetById(createdUser.Id);

                    response.Data = createdReferee;
                    response.statusCode = HttpStatusCode.OK;
                    response.Message = "Create referee success!";
                    transaction.Complete();
                }
                catch (Exception e)
                {
                    transaction.Dispose();
                    response.statusCode = HttpStatusCode.InternalServerError;
                    response.Message = e.Message;
                }
            return response;
        }
        private string GenerateRefreshToken()
        {
            return Convert.ToBase64String(RandomNumberGenerator.GetBytes(64));
        }

        public async Task<StatusResponse<List<UserResponseDTO>>> getAllPlayerUser()
        {
            var response = new StatusResponse<List<UserResponseDTO>>();
            try
            {
                var data = await _userRepository.Get().Include(x => x.Player).Where(x => x.RoleId == 1).ToListAsync();
                response.Data = _mapper.Map<List<UserResponseDTO>>(data);
                response.statusCode = HttpStatusCode.OK;
                response.Message = "Get all player user success!";
            }catch (Exception e)
            {
                response.statusCode = HttpStatusCode.InternalServerError;
                response.Message = e.Message;
            }
            return response;
        }
    }
}
