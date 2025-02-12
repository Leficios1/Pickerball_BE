using Database.Model;
using Microsoft.AspNetCore.Identity;
using Repository.Repository;
using Repository.Repository.Interfeace;
using Services.Mapping;
using Services.Services;
using Services.Services.Interface;

namespace PickerBall_BE.Extension
{
    public static class ServiceCollectionExtensions
    {
        public static IServiceCollection Register(this IServiceCollection services)
        {
            //Register AutoMapper
            services.AddAutoMapper(typeof(MappingEntites));


            //Register Repository here
            services.AddScoped(typeof(IBaseRepository<>), typeof(BaseRepository<>));
            services.AddScoped<IUserRepository, UserRepository>();
            services.AddScoped<IPlayerRepository, PlayerRepository>();
            services.AddScoped<ISponsorRepository, SponsorRepository>();

            //Register Services here
            services.AddScoped<IAuthServices, AuthServices>();
            services.AddScoped<IPasswordHasher<User>, PasswordHasher<User>>();
            services.AddScoped<IUserServices, UserServices>();
            services.AddScoped<IPlayerServices, PlayerServices>();

            return services;
        }
    }
}
