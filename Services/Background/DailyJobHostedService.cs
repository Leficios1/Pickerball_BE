using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using Services.Services.Interface;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Services.Background
{
    public class DailyJobHostedService : BackgroundService
    {
        private readonly IServiceProvider _serviceProvider;
        private readonly ILogger<DailyJobHostedService> _logger;

        public DailyJobHostedService(IServiceProvider serviceProvider, ILogger<DailyJobHostedService> logger)
        {
            _serviceProvider = serviceProvider;
            _logger = logger;
        }

        protected override async Task ExecuteAsync(CancellationToken stoppingToken)
        {
            while (!stoppingToken.IsCancellationRequested)
            {
                var now = DateTime.UtcNow.AddHours(7); // Giờ Việt Nam
                var nextRun = now.Date.AddDays(1); // 00:00 ngày tiếp theo

                var delay = nextRun - now;
                _logger.LogInformation($"Chờ {delay.TotalMinutes} phút đến 00:00...");

                await Task.Delay(delay, stoppingToken); // Chờ đến đúng 00:00

                try
                {
                    using var scope = _serviceProvider.CreateScope();
                    var myService = scope.ServiceProvider.GetRequiredService<IMyScheduledService>();

                    await myService.DoDailyTaskAsync();
                    _logger.LogInformation($"Đã thực hiện công việc lúc {DateTime.UtcNow.AddHours(7)}");
                }
                catch (Exception ex)
                {
                    _logger.LogError(ex, "Lỗi khi thực hiện công việc hằng ngày.");
                }
            }
        }
    }
}
