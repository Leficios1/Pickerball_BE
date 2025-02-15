using AutoMapper;
using Azure.Core;
using Database.DTO.Request;
using Database.DTO.Response;
using Database.Model;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.IdentityModel.Tokens;
using Repository.Repository;
using Repository.Repository.Interfeace;
using Services.Services.Interface;
using System;
using System.Collections.Generic;
using System.IdentityModel.Tokens.Jwt;
using System.Linq;
using System.Net;
using System.Security.Claims;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;
using static System.Net.WebRequestMethods;

namespace Services.Services
{
    public class AuthServices : IAuthServices
    {
        private readonly IUserRepository _userRepo;
        private readonly IConfiguration _configuration;
        private readonly IMapper _map;
        private readonly IPasswordHasher<User> _passwordHasher;

        public AuthServices(IUserRepository userRepo, IConfiguration configuration, IPasswordHasher<User> passwordHasher, IMapper mapper)
        {
            _userRepo = userRepo;
            _configuration = configuration;
            _passwordHasher = passwordHasher;
            _map = mapper;
        }

        public async Task<StatusResponse<TokenReponse>> LoginAccount(AuthRequestDTO dto)
        {
            var response = new StatusResponse<TokenReponse>();
            try
            {
                var checkUser = await _userRepo.Get()
                    .Include(x => x.Role)
                    .FirstOrDefaultAsync(u => u.Email.ToLower().Trim() == dto.Email.ToLower().Trim());

                if (checkUser == null || _passwordHasher.VerifyHashedPassword(checkUser, checkUser.PasswordHash, dto.Password) != PasswordVerificationResult.Success)
                {
                    response.statusCode = HttpStatusCode.Unauthorized;
                    response.Message = "Invalid email or password!";
                    return response;
                }
                else if (checkUser.Status == false)
                {
                    response.statusCode = HttpStatusCode.Unauthorized;
                    response.Message = "This account has been blocked!!!";
                    return response;
                }
                else
                {
                    var refreshToken = GenerateRefreshToken();

                    var token = GetToken(checkUser);
                    checkUser.RefreshToken = refreshToken;
                    checkUser.RefreshTokenExpiryTime = DateTime.UtcNow.AddDays(7);
                    _userRepo.Update(checkUser);
                    await _userRepo.SaveChangesAsync();

                    var tokenResponse = new TokenReponse
                    {
                        UserInfor = _map.Map<UserResponseDTO>(checkUser),
                        TokenString = new JwtSecurityTokenHandler().WriteToken(token),
                        Expiration = token.ValidTo,
                    };
                    response.Data = tokenResponse;
                    response.statusCode = HttpStatusCode.OK;
                    response.Message = "Login Successful!";
                    return response;
                }
            }
            catch (Exception ex)
            {
                response.statusCode = HttpStatusCode.InternalServerError;
                response.Message = ex.Message;
                return response;
            }
        }

        public string GenerateRefreshToken()
        {
            return Convert.ToBase64String(RandomNumberGenerator.GetBytes(64));
        }

        public JwtSecurityToken GetToken(User user)
        {
            List<Claim> authClaims = new List<Claim>
            {
                 new Claim(ClaimTypes.Name, user.FirstName),
                 new Claim(ClaimTypes.Email, user.Email),
                 new Claim(ClaimTypes.Role, user.RoleId.ToString()),
                 new Claim(ClaimTypes.NameIdentifier, user.Id.ToString())
            };

            var authSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_configuration["JWT:Secret"]));

            var token = new JwtSecurityToken(

                issuer: _configuration["JWT:ValidAudience"],
                audience: _configuration["JWT:ValidIssuer"],
                claims: authClaims,
                expires: DateTime.Now.AddDays(3),
                signingCredentials: new SigningCredentials(authSigningKey, SecurityAlgorithms.HmacSha256)
            );
            var refreshToken = Convert.ToBase64String(RandomNumberGenerator.GetBytes(64));
            return token;
        }

        public ClaimsPrincipal DecodeToken(string token)
        {
            var tokenHandler = new JwtSecurityTokenHandler();
            var key = Encoding.ASCII.GetBytes(_configuration["JWT:Secret"]);

            try
            {
                tokenHandler.ValidateToken(token, new TokenValidationParameters
                {
                    ValidateIssuerSigningKey = true,
                    IssuerSigningKey = new SymmetricSecurityKey(key),
                    ValidateIssuer = true,
                    ValidateAudience = true,
                    ValidIssuer = "http://localhost:5028",
                    ValidAudience = "http://localhost:5028",
                    ClockSkew = TimeSpan.Zero
                }, out SecurityToken validatedToken);

                var jwtToken = (JwtSecurityToken)validatedToken;
                var claimsIdentity = new ClaimsIdentity(jwtToken.Claims);

                return new ClaimsPrincipal(claimsIdentity);
            }
            catch (Exception ex)
            {
                // Xử lý trường hợp token không hợp lệ
                Console.WriteLine($"Token validation failed: {ex.Message}");
                return null;
            }
        }
        //public async Task<UserByTokenResponse> GetUserByToken(string token)
        //{
        //    var principals = DecodeToken(token);
        //    if (principals == null) throw new BadHttpRequestException("The token is invalid");

        //    var idClaim = principals.FindFirst(ClaimTypes.NameIdentifier);
        //    if (idClaim == null) throw new Exception("Token is invalid. There is no indentity of name");

        //    var id = idClaim.Value;
        //    var user = await _userRepo.Get().Select(x => new UserByTokenResponse()
        //    {
        //        Id = x.UserId,
        //        Name = x.Name,
        //        status = x.Status,
        //        DateOfBirth = x.DateOfBirth,
        //        AvatarUrl = x.AvatarUrl,
        //        Gender = x.Gender,
        //        Email = x.Email,
        //        phone = x.Phone,
        //        RoleId = x.RoleId,

        //    }).FirstOrDefaultAsync(x => x.Id.ToString().Equals(id));

        //    if (user == null) throw new Exception("There is no user has by id:");

        //    return user;

        //}
        private long ToUnixEpochDate(DateTime date)
        {
            return (long)Math.Round((date.ToUniversalTime() - new DateTime(1970, 1, 1, 0, 0, 0, DateTimeKind.Utc)).TotalSeconds);
        }

        public async Task<StatusResponse<UserResponseDTO>> RegisterAsync(UserRegisterRequestDTO dto)
        {
            var response = new StatusResponse<UserResponseDTO>();
            try
            {
                var existingUser = await _userRepo.GetByEmailAsync(dto.Email);
                if (existingUser != null)
                {
                    response.statusCode = HttpStatusCode.BadRequest;
                    response.Message = "Email already exists";
                    return response;
                }

                var user = new User
                {
                    Email = dto.Email,
                    FirstName = dto.FirstName,
                    LastName = dto.LastName,
                    SecondName = dto.SecondName,
                    DateOfBirth = dto.DateOfBirth,
                    AvatarUrl = "https://inkythuatso.com/uploads/thumbnails/800/2023/03/9-anh-dai-dien-trang-inkythuatso-03-15-27-03.jpg",
                    RoleId = dto.RoleId,
                    Status = true,
                    Gender = dto.Gender,
                    CreateAt = DateTime.UtcNow,
                    RefreshToken = GenerateRefreshToken(),
                    RefreshTokenExpiryTime = DateTime.UtcNow.AddDays(7)
                };

                user.PasswordHash = _passwordHasher.HashPassword(user, dto.PasswordHash);

                await _userRepo.AddAsync(user);
                await _userRepo.SaveChangesAsync();

                var userResponse = new UserResponseDTO
                {
                    Id = user.Id,
                    FirstName = user.FirstName,
                    LastName = user.LastName,
                    SecondName = user.SecondName,
                    Email = user.Email,
                    DateOfBirth = user.DateOfBirth,
                    AvatarUrl = user.AvatarUrl,
                    Gender = user.Gender,
                    Status = user.Status,
                    RoleId = user.RoleId,
                    RefreshToken = user.RefreshToken,
                    CreateAt = user.CreateAt,
                    RefreshTokenExpiryTime = user.RefreshTokenExpiryTime
                };

                response.Data = userResponse;
                response.statusCode = HttpStatusCode.OK;
                response.Message = "Registration Successful!";
                return response;
            }
            catch (Exception ex)
            {
                response.statusCode = HttpStatusCode.InternalServerError;
                response.Message = ex.Message;
                return response;
            }
        }

        public async Task<StatusResponse<RefershTokenResponseDTO>> getRefershToken(RefershTokenRequestDTO dto)
        {
            var response = new StatusResponse<RefershTokenResponseDTO>();
            try
            {
                var userInfo = await _userRepo.GetUserByRefershToken(dto.RefreshToken);
                if (userInfo == null || userInfo.RefreshTokenExpiryTime < DateTime.UtcNow)
                {
                    response.statusCode = HttpStatusCode.Unauthorized;
                    response.Message = "Invalid or expired refresh token";
                    return response;
                }
                var newAccessToken = GetToken(userInfo);
                var newRefreshToken = GenerateRefreshToken();

                userInfo.RefreshToken = newRefreshToken;
                userInfo.RefreshTokenExpiryTime = DateTime.UtcNow.AddDays(7);

                _userRepo.Update(userInfo);
                await _userRepo.SaveChangesAsync();

                response.Data = new RefershTokenResponseDTO
                {
                    TokenString = new JwtSecurityTokenHandler().WriteToken(newAccessToken),
                    RefreshToken = newRefreshToken
                };
                response.statusCode = HttpStatusCode.OK;
                response.Message = "Token refreshed successfully!";
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
