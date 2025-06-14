﻿using AutoMapper;
using Azure;
using Azure.Core;
using Database.DTO.Request;
using Database.DTO.Response;
using Database.Model;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.IdentityModel.Tokens;
using MimeKit;
using Repository.Repository;
using Repository.Repository.Interfeace;
using Services.Services.Interface;
using System;
using System.Collections.Generic;
using System.IdentityModel.Tokens.Jwt;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Security.Claims;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;
using static System.Net.WebRequestMethods;
using MailKit.Net.Smtp;
using MimeKit;

namespace Services.Services
{
    public class AuthServices : IAuthServices
    {
        private readonly IUserRepository _userRepo;
        private readonly IConfiguration _configuration;
        private readonly IMapper _map;
        private readonly IPasswordHasher<User> _passwordHasher;

        public AuthServices(IUserRepository userRepo, IConfiguration configuration,
            IPasswordHasher<User> passwordHasher, IMapper mapper)
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

                if (checkUser == null ||
                    _passwordHasher.VerifyHashedPassword(checkUser, checkUser.PasswordHash, dto.Password) !=
                    PasswordVerificationResult.Success)
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

        public async Task<UserResponseDTO> GetUserByToken(string token)
        {
            var principals = DecodeToken(token);
            if (principals == null) throw new BadHttpRequestException("The token is invalid");

            var idClaim = principals.FindFirst(ClaimTypes.NameIdentifier);
            if (idClaim == null) throw new Exception("Token is invalid. There is no indentity of name");


            var id = idClaim.Value;
            var user = await _userRepo.Get().Select(x => new UserResponseDTO()
            {
                Id = x.Id,
                FirstName = x.FirstName,
                LastName = x.LastName,
                SecondName = x.SecondName,
                Status = x.Status,
                DateOfBirth = x.DateOfBirth,
                AvatarUrl = x.AvatarUrl,
                PhoneNumber = x.PhoneNumber,
                Gender = x.Gender,
                Email = x.Email,
                RefreshToken = x.RefreshToken,
                RefreshTokenExpiryTime = x.RefreshTokenExpiryTime,
                CreateAt = x.CreateAt,
                RoleId = x.RoleId,
                //userDetails = new PlayerDetails
                //{
                //    CCCD = x.Player.CCCD,
                //    Province = x.Player.Province,
                //    City = x.Player.City,
                //    ExperienceLevel = x.Player.ExperienceLevel,
                //    RankingPoint = x.Player.RankingPoint,
                //    TotalMatch = x.Player.TotalMatch,
                //    TotalWins = x.Player.TotalWins,
                //}
            }).SingleOrDefaultAsync(x => x.Id.ToString().Equals(id));
            if (user.RoleId == 1)
            {
                var userDetails = await _userRepo.Get().Where(x => x.Id == user.Id).Include(x => x.Player).SingleOrDefaultAsync();
                if (userDetails == null) throw new Exception("There is no user has by id:");
                user.userDetails = new PlayerDetails
                {
                    CCCD = userDetails.Player.CCCD,
                    Province = userDetails.Player.Province,
                    City = userDetails.Player.City,
                    ExperienceLevel = userDetails.Player.ExperienceLevel,
                    RankingPoint = userDetails.Player.RankingPoint,
                    TotalMatch = userDetails.Player.TotalMatch,
                    TotalWins = userDetails.Player.TotalWins,
                };
            }

            if (user == null) throw new Exception("There is no user has by id:");

            return user;

        }

        private long ToUnixEpochDate(DateTime date)
        {
            return (long)Math.Round((date.ToUniversalTime() - new DateTime(1970, 1, 1, 0, 0, 0, DateTimeKind.Utc))
                .TotalSeconds);
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
                var checkUser = await _userRepo.Get().Where(x => x.PhoneNumber == dto.PhoneNumber).SingleOrDefaultAsync();
                if (checkUser != null)
                {
                    response.statusCode = HttpStatusCode.BadRequest;
                    response.Message = "Phone Number already exists";
                    return response;
                }
                var user = new User
                {
                    Email = dto.Email,
                    FirstName = dto.FirstName,
                    LastName = dto.LastName,
                    SecondName = dto.SecondName,
                    DateOfBirth = dto.DateOfBirth,
                    AvatarUrl =
                        "https://inkythuatso.com/uploads/thumbnails/800/2023/03/9-anh-dai-dien-trang-inkythuatso-03-15-27-03.jpg",
                    Status = true,
                    Gender = dto.Gender,
                    CreateAt = DateTime.UtcNow,
                    PhoneNumber = dto.PhoneNumber,
                    RefreshToken = GenerateRefreshToken(),
                    RefreshTokenExpiryTime = DateTime.UtcNow.AddDays(7),
                    RoleId = 5
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
                    RefreshToken = user.RefreshToken,
                    CreateAt = user.CreateAt,
                    RefreshTokenExpiryTime = user.RefreshTokenExpiryTime,
                    RoleId = user.RoleId
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
        public async Task<StatusResponse<UserResponseDTO>> RefereeRegisterAsync(UserRegisterRequestDTO dto)
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
                    Status = true,
                    Gender = dto.Gender,
                    CreateAt = DateTime.UtcNow,
                    RefreshToken = GenerateRefreshToken(),
                    RefreshTokenExpiryTime = DateTime.UtcNow.AddDays(7),
                    RoleId = 5
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

        public async Task<StatusResponse<bool>> UpdatePassword(int userId, string newPassword)
        {
            var response = new StatusResponse<bool>();
            try
            {
                var checkUser = await _userRepo.Get()
                    .Include(x => x.Role)
                    .FirstOrDefaultAsync(u => u.Id == userId);
                if (checkUser == null)
                {
                    response.statusCode = HttpStatusCode.NotFound;
                    response.Message = "Not found user";
                    return response;
                }
                checkUser.PasswordHash = _passwordHasher.HashPassword(checkUser, newPassword);
                _userRepo.Update(checkUser);
                await _userRepo.SaveChangesAsync();
                response.Data = true;
                response.statusCode = HttpStatusCode.OK;
                response.Message = "Update Password Succesfull";
            }
            catch (Exception ex)
            {
                response.statusCode = HttpStatusCode.InternalServerError;
                response.Message = ex.Message;
            }
            return response;
        }

        public async Task<StatusResponse<int>> ForgotPassword(string email)
        {
            var response = new StatusResponse<int>();
            try
            {
                var data = await _userRepo.GetByEmailAsync(email);
                if (data == null)
                {
                    response.statusCode = HttpStatusCode.NotFound;
                    response.Message = "Not Found User";
                    return response;
                }
                response.Data = data.Id;
                response.statusCode = HttpStatusCode.OK;
                response.Message = "Ok";
            }
            catch (Exception ex)
            {
                response.Message = ex.Message;
                response.statusCode = HttpStatusCode.InternalServerError;
            }
            return response;
        }

        public async Task<StatusResponse<bool>> CheckPasswordCorrectOrNot(int userId, string password)
        {
            var response = new StatusResponse<bool>();
            try
            {
                var checkUser = await _userRepo.Get()
                    .Include(x => x.Role)
                    .FirstOrDefaultAsync(u => u.Id == userId);
                if (checkUser == null || _passwordHasher.VerifyHashedPassword(checkUser, checkUser.PasswordHash, password) != PasswordVerificationResult.Success)
                {
                    response.Data = false;
                    response.statusCode = HttpStatusCode.Unauthorized;
                    response.Message = "Invalid email or password!";
                    return response;
                }
                response.Data = true;
                response.statusCode = HttpStatusCode.OK;
                response.Message = "Update Password Succesfull";
            }
            catch (Exception ex)
            {
                response.statusCode = HttpStatusCode.InternalServerError;
                response.Message = ex.Message;
            }
            return response;
        }

        public async Task<StatusResponse<VerifyEmailResponseDTO>> VerifyEmailAsync(string email)
        {
            var response = new StatusResponse<VerifyEmailResponseDTO>();
            try
            {
                var otp = new Random().Next(100000, 999999);
                string html = $@"
<!DOCTYPE html>
<html lang=""vi"">
<head>
    <meta charset=""UTF-8"">
    <title>Xác thực OTP</title>
    <style>
        body {{
            font-family: Arial, sans-serif;
            background-color: #f6f8fb;
            color: #333;
            padding: 20px;
        }}
        .container {{
            max-width: 500px;
            margin: auto;
            background-color: #ffffff;
            border-radius: 10px;
            padding: 30px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            text-align: center;
        }}
        .otp-code {{
            font-size: 32px;
            font-weight: bold;
            color: #2d89ef;
            margin: 20px 0;
        }}
        .message {{
            font-size: 16px;
        }}
        .footer {{
            margin-top: 30px;
            font-size: 12px;
            color: #888;
        }}
    </style>
</head>
<body>
    <div class=""container"">
        <h2>Xác thực tài khoản của bạn</h2>
        <p class=""message"">Sử dụng mã OTP dưới đây để xác thực địa chỉ email của bạn:</p>
        <div class=""otp-code"">{otp}</div>
        <p class=""message"">Mã có hiệu lực trong 5 phút. Vui lòng không chia sẻ mã này với bất kỳ ai.</p>
        <div class=""footer"">Nếu bạn không yêu cầu xác thực này, hãy bỏ qua email này.</div>
    </div>
</body>
</html>";
                var Sendemail = new MimeMessage();
                Sendemail.From.Add(MailboxAddress.Parse(_configuration["EmailSettings:SenderEmail"]));
                Sendemail.To.Add(MailboxAddress.Parse(email));
                Sendemail.Subject = "Xác thực Email - OTP";
                Sendemail.Body = new TextPart(MimeKit.Text.TextFormat.Html)
                {
                    Text = html
                };

                using var smtp = new MailKit.Net.Smtp.SmtpClient();
                await smtp.ConnectAsync("smtp.gmail.com", 587, MailKit.Security.SecureSocketOptions.StartTls);
                await smtp.AuthenticateAsync(_configuration["EmailSettings:SenderEmail"], _configuration["EmailSettings:AppPassword"]);
                await smtp.SendAsync(Sendemail);
                await smtp.DisconnectAsync(true);

                response.Data = new VerifyEmailResponseDTO
                {
                    Email = email,
                    OTP = otp
                };
                response.statusCode = HttpStatusCode.OK;
                response.Message = "OTP đã được gửi đến email của bạn.";
            }
            catch(Exception ex)
            {
                response.statusCode = HttpStatusCode.InternalServerError;
                response.Message = "Lỗi gửi email: " + ex.Message;
            }
            return response;
        }

        public Task<StatusResponse<VerifyEmailResponseDTO>> restPassword(string email)
        {
            throw new NotImplementedException();
        }
    }
}
