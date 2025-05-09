using Database.Model.Dbcontext;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using Microsoft.OpenApi.Models;
using System.Text;
using Services.Services;
using Services.Services.Interface;
using Database.Helper;
using Microsoft.Extensions.Configuration;
using Repository.Repository.Interfeace;
using Repository.Repository;
using Repository.Repository.Interface;
using Database.Model;
using Microsoft.AspNetCore.Identity;
using Services.Real_Time;
using Microsoft.Azure.SignalR;
using Net.payOS;
using Database.DTO.PayOsDTO;


IConfiguration configuration = new ConfigurationBuilder().AddJsonFile("appsettings.json").Build();

PayOS payOS = new PayOS(configuration["Environment:PAYOS_CLIENT_ID"] ?? throw new Exception("Cannot find environment"),
                    configuration["Environment:PAYOS_API_KEY"] ?? throw new Exception("Cannot find environment"),
                    configuration["Environment:PAYOS_CHECKSUM_KEY"] ?? throw new Exception("Cannot find environment"));

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
PickerBall_BE.Extension.ServiceCollectionExtensions.Register(builder.Services);

builder.Services.AddControllers();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

builder.Services.AddCors(options =>
{
    //options.AddPolicy("AllowAll",
    //    builder =>
    //    {
    //        builder
    //            .AllowAnyOrigin()
    //            .AllowAnyMethod()
    //            .AllowAnyHeader();
    //    });
    options.AddPolicy("AllowFrontend", policy =>
    {
        policy.WithOrigins("http://192.168.56.1:5500", "https://pickleball-admin-dlby.vercel.app", "http://localhost:5173",
            "http://localhost:52124", "https://score-pickle.vercel.app", "https://pickleball-admin-brfb.vercel.app",
            "http://pickleball-admin.vercel.app", "https://pickleball-admin-zcg1.vercel.app") 
              .AllowAnyHeader()
              .AllowAnyMethod()
              .AllowCredentials(); 
    });
});

builder.Services.AddDbContext<PickerBallDbcontext>(options =>
{
    options.UseSqlServer(builder.Configuration.GetConnectionString("PickerBall"));
});
builder.Services.AddAutoMapper(typeof(Program));
//PayOsConfig
builder.Services.Configure<PayOsSettings>(builder.Configuration.GetSection("PayOS"));
builder.Services.AddHttpClient<PayOsServices>(); // cho HttpClient
builder.Services.AddMemoryCache();

//Add JSON 
builder.Services.AddControllers().AddJsonOptions(options =>
{
    options.JsonSerializerOptions.MaxDepth = 256;
});

//Add Authencation
builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
  .AddJwtBearer(options =>
  {
      options.SaveToken = true;
      options.TokenValidationParameters = new TokenValidationParameters
      {
          ValidateIssuer = true,
          ValidateAudience = true,
          ValidateLifetime = true,
          ValidateIssuerSigningKey = true,
          ValidAudience = builder.Configuration["JWT:ValidAudience"],
          ValidIssuer = builder.Configuration["JWT:ValidIssuer"],
          IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(builder.Configuration["JWT:Secret"]))

      };
  });
builder.Services.AddScoped<IMatchService, MatchService>();
builder.Services.AddScoped<IRefreeRepository, RefreeRepository>();
builder.Services.AddSwaggerGen(opt =>
{
    opt.SwaggerDoc("v1", new OpenApiInfo { Title = "PickerBall", Version = "v1" });
    opt.AddSecurityDefinition("Bearer", new OpenApiSecurityScheme
    {
        In = ParameterLocation.Header,
        Description = "Please enter token",
        Name = "Authorization",
        Type = SecuritySchemeType.Http,
        BearerFormat = "JWT",
        Scheme = "bearer"
    });

    opt.AddSecurityRequirement(new OpenApiSecurityRequirement
                    {
                    {
                        new OpenApiSecurityScheme
                        {
                            Reference = new OpenApiReference
                            {
                                Type = ReferenceType.SecurityScheme,
                                Id = "Bearer"
                            }
                    },
                        Array.Empty<string>()
        }
    });
});
builder.Services.AddSignalR().AddAzureSignalR(builder.Configuration["Azure:SignalRConnectionString"]);
builder.Logging.ClearProviders();
builder.Logging.AddConsole();

builder.Services.Configure<VnpayConfig>(builder.Configuration.GetSection("VNPAY"));
builder.Services.AddHttpContextAccessor();
var app = builder.Build();

using (var scope = app.Services.CreateScope())
{
    var services = scope.ServiceProvider;
    await DbSeeder.SeedAsync(services);
}

app.UseCors("AllowFrontend");
app.UseDeveloperExceptionPage();
app.UseSwagger();

app.UseSwaggerUI(options =>
{

    options.SwaggerEndpoint("/swagger/v1/swagger.json", "v1");
    options.RoutePrefix = string.Empty;

});
app.UseHttpsRedirection();
app.UseRouting();
app.UseAuthentication();
app.UseAuthorization();

app.UseEndpoints(endpoints =>
{
    endpoints.MapControllers();
    endpoints.MapHub<MatchHub>("/matchHub");

});


app.MapControllers();

app.Run();
