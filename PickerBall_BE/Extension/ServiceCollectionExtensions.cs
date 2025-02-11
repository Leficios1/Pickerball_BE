using Database.Model;
using Microsoft.AspNetCore.Identity;
using Repository.Repository;
using Repository.Repository.Interfeace;
using Services.Services;
using Services.Services.Interface;

namespace PickerBall_BE.Extension
{
    public static class ServiceCollectionExtensions
    {
        public static IServiceCollection Register(this IServiceCollection services)
        {
            //Register AutoMapper
            //services.AddAutoMapper(typeof(MappingEntites));
            
            //Register Repository here
            services.AddScoped(typeof(IBaseRepository<>), typeof(BaseRepository<>));
            services.AddScoped<IUserRepository, UserRepository>();
            //Register Services here
            services.AddScoped<IAuthServices, AuthServices>();
            services.AddScoped<IPasswordHasher<User>, PasswordHasher<User>>();


            return services;
        }
    }
}
