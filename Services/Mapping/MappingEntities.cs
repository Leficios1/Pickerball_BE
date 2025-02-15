using AutoMapper;
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
                .ForMember(dest => dest.Id, opt => opt.MapFrom(src => src.UserId)).ReverseMap();

            CreateMap<User, UserResponseDTO>()
                .ForMember(dest => dest.userDetails, opt => opt.MapFrom(src => src.Player))
                .ForMember(dest => dest.sponsorDetails, opt => opt.MapFrom(src => src.Sponsor));

            CreateMap<PlayerDetails, Player>().ReverseMap();
            CreateMap<SponsorDetails, Sponsor>().ReverseMap();
            CreateMap<PlayerDetailsRequest, Player>().ReverseMap();

            // use to DTO
            CreateMap<MatchRequestDTO, Matches>().ReverseMap();
            CreateMap<MatchResponseDTO, Matches>().ReverseMap();
            CreateMap<CreateRoomDTO, Matches>().ReverseMap();
            CreateMap<RoomResponseDTO, Matches>().ReverseMap();
            CreateMap<TeamRequestDTO, Team>().ReverseMap();
            CreateMap<TeamResponseDTO, Team>().ReverseMap();
            CreateMap<TeamMemberRequestDTO, TeamMembers>().ReverseMap();
            CreateMap<TeamMemberDTO, TeamMembers>().ReverseMap();
        }
    }
}