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
    public class PlayerServices : IPlayerServices
    {
        private readonly IPlayerRepository _playerRepository;
        private readonly IMapper _mapper;

        public PlayerServices(IPlayerRepository playerRepository, IMapper mapper)
        {
            _playerRepository = playerRepository;
            _mapper = mapper;
        }

        public async Task<StatusResponse<PlayerDetails>> CreatePlayer(PlayerDetailsRequest player)
        {
            var response = new StatusResponse<PlayerDetails>();
            try
            {
                var data = await _playerRepository.GetById(player.PlayerId);
                if (data != null)
                {
                    response.Message = "Player already exist";
                    response.statusCode = HttpStatusCode.BadRequest;
                    return response;
                }
                var requestData = _mapper.Map<Player>(player);
                requestData.TotalMatch = 0;
                requestData.TotalWins = 0;
                requestData.RankingPoint = 0;
                requestData.ExperienceLevel = 1;
                var responseData = await _playerRepository.CreatePlayer(requestData);
                response.Data = _mapper.Map<PlayerDetails>(responseData);
                response.Message = "Create player success!";
                response.statusCode = HttpStatusCode.OK;
            }catch (Exception e)
            {
                response.Message = e.Message;
                response.statusCode = HttpStatusCode.InternalServerError;
            }
            return response;
        }
    }
}
