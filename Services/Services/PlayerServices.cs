﻿using AutoMapper;
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
        private readonly IUserRepository _userRepository;   
        private readonly IMapper _mapper;

        public PlayerServices(IPlayerRepository playerRepository, IMapper mapper, IUserRepository userRepository)
        {
            _playerRepository = playerRepository;
            _mapper = mapper;
            _userRepository = userRepository;
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
                var dataUser = await _userRepository.GetById(player.PlayerId);
                if (dataUser == null)
                {
                    response.Message = "User not found";
                    response.statusCode = HttpStatusCode.NotFound;
                    return response;
                }
                dataUser.RoleId = 1;
                var responseData = await _playerRepository.CreatePlayer(requestData);
                _userRepository.Update(dataUser);
                await _userRepository.SaveChangesAsync();
                response.Data = _mapper.Map<PlayerDetails>(responseData);
                response.Message = "Create player success!";
                response.statusCode = HttpStatusCode.OK;
            }
            catch (Exception e)
            {
                response.Message = e.Message;
                response.statusCode = HttpStatusCode.InternalServerError;
            }
            return response;
        }

        public async Task<StatusResponse<List<PlayerDetails>>> GetAllPlayers()
        {
            var response = new StatusResponse<List<PlayerDetails>>();
            try
            {
                var data = await _playerRepository.GetAllPlayer();
                if (data == null)
                {
                    response.Message = "Player not found";
                    response.statusCode = HttpStatusCode.NotFound;
                    return response;
                }
                response.Data = _mapper.Map<List<PlayerDetails>>(data);
                response.Message = "Get all player success!";
                response.statusCode = HttpStatusCode.OK;

            }
            catch (Exception e)
            {
                response.Message = e.Message;
                response.statusCode = HttpStatusCode.InternalServerError;
            }
            return response;
        }

        public async Task<StatusResponse<PlayerDetails>> GetPlayerById(int PlayerId)
        {
            var response = new StatusResponse<PlayerDetails>();
            try
            {
                var data = await _playerRepository.GetById(PlayerId);
                if (data == null)
                {
                    response.Message = "Player not found";
                    response.statusCode = HttpStatusCode.NotFound;
                    return response;
                }
                response.Data = _mapper.Map<PlayerDetails>(data);
                response = new StatusResponse<PlayerDetails>();
                response.Message = "Get player success!";
            }
            catch (Exception e)
            {
                response.Message = e.Message;
                response.statusCode = HttpStatusCode.InternalServerError;
            }
            return response;
        }

        public async Task<StatusResponse<PlayerDetails>> UpdatePlayer(PlayerDetailsRequest player)
        {
            var response = new StatusResponse<PlayerDetails>();
            try
            {
                var data = _playerRepository.GetById(player.PlayerId);
                if (data == null)
                {
                    response.Message = "Player not found";
                    response.statusCode = HttpStatusCode.NotFound;
                    return response;
                }
                var requestData = _mapper.Map<Player>(player);
                await _playerRepository.UpdatePlayer(requestData);
                await _playerRepository.SaveChangesAsync();
                response.Data = _mapper.Map<PlayerDetails>(requestData);
                response.Message = "Update player success!";
                response.statusCode = HttpStatusCode.OK;
            }
            catch (Exception e)
            {
                response.Message = e.Message;
                response.statusCode = HttpStatusCode.InternalServerError;
            }
            return response;
        }
    }
}
