using Database.Model;
using Microsoft.AspNetCore.Identity;
using Repository.Repository;
using Repository.Repository.Interface;
using Repository.Repository.Interfeace;
using Services.Mapping;
using Services.Services;
using Services.Services.Interface;
using IMatchesRepository = Repository.Repository.Interface.IMatchesRepository;

namespace PickerBall_BE.Extension
{
    public static class ServiceCollectionExtensions
    {
        public static IServiceCollection Register(this IServiceCollection services)
        {
            //Register AutoMapper
            services.AddAutoMapper(typeof(MappingEntites));


            // Register Repository here
            services.AddScoped(typeof(IBaseRepository<>), typeof(BaseRepository<>));
            services.AddScoped<IUserRepository, UserRepository>();
            services.AddScoped<IPlayerRepository, PlayerRepository>();
            services.AddScoped<ISponsorRepository, SponsorRepository>();
            services.AddScoped<IMatchesRepository, MatchesRepository>();
            services.AddScoped<ITeamMembersRepository, TeamMembersRepository>();
            services.AddScoped<ITeamRepository, TeamRepository>();
            services.AddScoped<ITournamentRegistrationRepository, TournamentRegistrationRepository>();
            services.AddScoped<ITouramentRepository, TouramentRepository>();
            services.AddScoped<IPaymentRepository, PaymentRepository>();
            services.AddScoped<ITouramentMatchesRepository, TouramentMatchesRepository>();
            services.AddScoped<IBlogCategoriesRepository, BlogCategoriesRepository>();
            services.AddScoped<IRuleRepository, RuleRepository>();
            services.AddScoped<IMatchSentRequestRepository, MatchSentRequestRepository>();
            services.AddScoped<IFriendRepository, FriendRepository>();
            services.AddScoped<IVenusRepository, VenuesRepository>();
            services.AddScoped<ISponserTouramentRepository, SponserTouramentRepository>();
            services.AddScoped<ITournamentTeamRequestRepository, TournamentTeamRequestRepository>();
            services.AddScoped<INotificationRepository, NotificationRepository>();
            services.AddScoped<IVnpayRepository, VnpayRepository>();


            // Register Services here
            services.AddScoped<IAuthServices, AuthServices>();
            services.AddScoped<IMatchService, MatchService>();
            services.AddScoped<IPasswordHasher<User>, PasswordHasher<User>>();
            services.AddScoped<IUserServices, UserServices>();
            services.AddScoped<IPlayerServices, PlayerServices>();
            services.AddScoped<ITeamMembersService, TeamMembersService>();
            services.AddScoped<ITeamService, TeamService>();
            services.AddScoped<IMatchService, MatchService>();
            services.AddScoped<ITouramentServices, TouramentServices>();
            services.AddScoped<ITouramentRegistrationServices, TouramentRegistrationServices>();
            services.AddScoped<ISponnerServices, SponnerServices>();
            services.AddScoped<IBlogCategory, BlogCategoryService>();
            services.AddScoped<IRuleService, RuleService>();
            services.AddScoped<IMatchSentRequestServices, MatchSentRequestServices>();
            services.AddScoped<IFriendServices, FriendServices>();
            services.AddScoped<IVenuesServices, VenuesServices>();
            services.AddScoped<ITournamentTeamRequestServices, TournamentTeamRequestServices>();
            services.AddScoped<INotificationServices, NotificationServices>();
            services.AddScoped<IVnpayService, VnpayService>();

            return services;
        }
    }
}
