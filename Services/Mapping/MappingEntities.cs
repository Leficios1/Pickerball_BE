﻿using AutoMapper;
using Database.DTO.Request;
using Database.DTO.Response;
using Database.Model;

namespace Services.Mapping
{
    public class MappingEntites : Profile
    {
        public MappingEntites()
        {
            CreateMap<UserUpdateRequestDTO, User>()
                .ForAllMembers(opts => opts.Condition((src, dest, srcMember) => srcMember != null));

            CreateMap<User, UserResponseDTO>()
                       .ForMember(dest => dest.userDetails, opt => opt.MapFrom(src => src.Player))
                       .ForMember(dest => dest.sponsorDetails, opt => opt.MapFrom(src => src.Sponsor));

            CreateMap<MatchRequestDTO, Matches>().ReverseMap();
            CreateMap<MatchResponseDTO, Matches>().ReverseMap();
            CreateMap<CreateRoomDTO, Matches>().ReverseMap();
            CreateMap<MatchResponseDTO, RoomResponseDTO>().ReverseMap();
            CreateMap<RoomResponseDTO, Matches>().ReverseMap();
            CreateMap<TeamRequestDTO, Team>().ReverseMap();
            CreateMap<TeamResponseDTO, Team>().ReverseMap();
            CreateMap<TeamMemberRequestDTO, TeamMembers>().ReverseMap();
            CreateMap<TeamMemberDTO, TeamMembers>().ReverseMap();
            CreateMap<PlayerDetails, Player>().ReverseMap();
            CreateMap<SponsorDetails, Sponsor>().ReverseMap();
            CreateMap<PlayerDetailsRequest, Player>().ReverseMap();
            CreateMap<TournamentRequestDTO, Tournaments>().ReverseMap();
            CreateMap<Tournaments, TournamentResponseDTO>().ReverseMap();
            CreateMap<MatchResponseDTO, Matches>().ReverseMap();
            CreateMap<MatchRequestDTO, Matches>().ReverseMap();
            CreateMap<SponnerRequestDTO, Sponsor>().ReverseMap();
            CreateMap<Sponsor, SponnerResponseDTO>().ReverseMap();

            CreateMap<RefereeCreateRequestDTO, User>().ReverseMap();

            //Mapping for Blog Category
            CreateMap<BlogCategoryCreateDTO, BlogCategory>().ReverseMap();
            CreateMap<BlogCategoryDTO, BlogCategory>().ReverseMap();
            CreateMap<BlogCategory, BlogCategoryDTO>().ReverseMap();
            CreateMap<PagingResult<BlogCategory>, PagingResult<BlogCategoryDTO>>();

            //Mapping for Rule(Blog,Content,News)
            CreateMap<RuleCreateDTO, Rule>().ReverseMap();
            CreateMap<RuleUpdateDTO, Rule>()
                .ForAllMembers(opts => opts.Condition((src, dest, srcMember) => srcMember != null));
            CreateMap<Rule, RuleResponseDTO>().ReverseMap();
            CreateMap<PagingResult<Rule>, PagingResult<RuleResponseDTO>>();

            CreateMap<MatchSentRequestRequestDTO, MatchesSendRequest>().ReverseMap();
            CreateMap<MatchesSendRequest, MatchSentRequestResponseDTO>().ReverseMap();
            CreateMap<FriendRequestDTO, Friends>().ReverseMap();
            CreateMap<FriendResponseDTO, Friends>().ReverseMap();
            CreateMap<VenuesRequestDTO, Venues>().ReverseMap();
            CreateMap<Venues, VenuesResponseDTO>().ReverseMap(); 


        }
    }
}
