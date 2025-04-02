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
    public class RakingServices : IRankingServices
    {
        private readonly IUserRepository _userRepository;
        private readonly IPlayerRepository _playerRepository;
        private readonly IMapper _mapper;

        public RakingServices(IUserRepository userRepository, IPlayerRepository playerRepository, IMapper mapper)
        {
            _userRepository = userRepository;
            _playerRepository = playerRepository;
            _mapper = mapper;
        }

        public async Task<StatusResponse<List<RankingResponseDTO>>> LeaderBoard()
        {
            var response = new StatusResponse<List<RankingResponseDTO>>();
            try
            {
                var data = await _userRepository.Get().Include(x => x.Player).OrderByDescending(x => x.Player.RankingPoint).Take(50).ToListAsync();
                response.Data = _mapper.Map<List<RankingResponseDTO>>(data);
                response.Message = "Get LeaderBoard Success";
                response.statusCode = System.Net.HttpStatusCode.OK;
            }catch (Exception ex) {
                response.Message = ex.Message;
                response.statusCode = System.Net.HttpStatusCode.InternalServerError;
            }
            return response;
        }
    }
}
