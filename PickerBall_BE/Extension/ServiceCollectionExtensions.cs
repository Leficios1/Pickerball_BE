using Database.Model;
using Microsoft.AspNetCore.Identity;
using Repository.Repository;
using Repository.Repository.Interface;
using Repository.Repository.Interfeace; // Corrected namespace
using Services.Services;
using Services.Services.Interface;
using IMatchesRepository = Repository.Repository.Interface.IMatchesRepository;

namespace PickerBall_BE.Extension
{
    public static class ServiceCollectionExtensions
    {
        public static IServiceCollection Register(this IServiceCollection services)
        {
            // Register AutoMapper
            // services.AddAutoMapper(typeof(MappingEntites));

            // Register Repository here
            services.AddScoped(typeof(IBaseRepository<>), typeof(BaseRepository<>));
            services.AddScoped<IUserRepository, UserRepository>();
            services.AddScoped<IMatchesRepository, MatchesRepository>();
            services.AddScoped<ITeamMembersRepository, TeamMembersRepository>();
            services.AddScoped<ITeamRepository, TeamRepository>();

            // Register Services here
            services.AddScoped<IAuthServices, AuthServices>();
            services.AddScoped<IMatchService, MatchService>();
            services.AddScoped<IPasswordHasher<User>, PasswordHasher<User>>();

            return services;
        }
    }
}
