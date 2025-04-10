using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;

namespace Database.Model.Dbcontext
{
    public class DbSeeder
    {
        public static async Task SeedAsync(IServiceProvider serviceProvider)
        {
            using var scope = serviceProvider.CreateScope();
            var context = scope.ServiceProvider.GetRequiredService<PickerBallDbcontext>();
            var passwordHasher = scope.ServiceProvider.GetRequiredService<IPasswordHasher<User>>();

            if (!context.Users.Any())
            {
                var users = new List<User>();
                var players = new List<Player>();

                for (int i = 1; i <= 30; i++)
                {
                    var user = new User
                    {
                        FirstName = $"Player{i}",
                        LastName = "Test",
                        Email = $"player{i}@gmail.com",
                        DateOfBirth = new DateTime(1995, 1, 1).AddDays(i * 30),
                        Gender = i % 2 == 0 ? "Male" : "Female",
                        RoleId = 1,
                        Status = true,
                        RefreshToken = Convert.ToBase64String(RandomNumberGenerator.GetBytes(64)),
                        RefreshTokenExpiryTime = DateTime.UtcNow.AddDays(7),
                        PhoneNumber = $"09000000{i:D2}",
                        AvatarUrl = "https://inkythuatso.com/uploads/thumbnails/800/2023/03/9-anh-dai-dien-trang-inkythuatso-03-15-27-03.jpg",
                        CreateAt = DateTime.UtcNow
                    };

                    user.PasswordHash = passwordHasher.HashPassword(user, "Thangban123@");
                    users.Add(user);
                }

                await context.Users.AddRangeAsync(users);
                await context.SaveChangesAsync();

                // Tạo Player sau khi Users đã có Id
                var createdUsers = await context.Users.Where(u => u.RoleId == 1).ToListAsync();
                foreach (var u in createdUsers)
                {
                    players.Add(new Player
                    {
                        PlayerId = u.Id,
                        Province = u.Id % 2 == 0 ? "HCM" : "HN",
                        City = u.Id % 2 == 0 ? "HCM" : "HN",
                        CCCD = $"12345678900{u.Id:D2}",
                        ExperienceLevel = u.Id % 10,
                        RankingPoint = u.Id * 50,
                        TotalWins = u.Id,
                        TotalMatch = u.Id * 2
                    });
                }

                await context.Player.AddRangeAsync(players);
                await context.SaveChangesAsync();
            }
            if (!context.Users.Any(u => u.RoleId == 3)) // RoleId = 3 là Sponsor
            {
                var sponsorUsers = new List<User>();
                var sponsors = new List<Sponsor>();

                for (int i = 1; i <= 10; i++)
                {
                    var refreshToken = Convert.ToBase64String(RandomNumberGenerator.GetBytes(64));
                    var dob = new DateTime(1990, 1, 1).AddDays(i * 30);
                    var gender = i % 2 == 0 ? "Male" : "Female";

                    var user = new User
                    {
                        FirstName = $"Sponsor{i}",
                        LastName = "Test",
                        Email = $"sponsor{i}@gmail.com",
                        PasswordHash = "", // Sẽ hash phía dưới
                        DateOfBirth = dob,
                        AvatarUrl = "https://inkythuatso.com/uploads/thumbnails/800/2023/03/9-anh-dai-dien-trang-inkythuatso-03-15-27-03.jpg",
                        Gender = gender,
                        Status = true,
                        RoleId = 3, // Sponsor
                        RefreshToken = refreshToken,
                        RefreshTokenExpiryTime = DateTime.UtcNow.AddDays(7),
                        PhoneNumber = $"09111111{i:D2}",
                        CreateAt = DateTime.UtcNow
                    };

                    user.PasswordHash = passwordHasher.HashPassword(user, "Thangban123@");
                    sponsorUsers.Add(user);
                }
                await context.Users.AddRangeAsync(sponsorUsers);
                await context.SaveChangesAsync();

                var createdSponsor = await context.Users.Where(u => u.RoleId == 3).ToListAsync();
                foreach (var u in createdSponsor)
                {

                    sponsors.Add(new Sponsor
                    {
                        SponsorId = u.Id,
                        CompanyName = $"Company Sponsor {u.Id}",
                        ContactEmail = u.Email,
                        isAccept = true,
                        JoinedAt = DateTime.UtcNow,
                        LogoUrl = "https://tiki.vn/blog/wp-content/uploads/2023/04/yG5nTqJEp3Mr4fzYGR0h1JngusoVegJ4mJHa7K-XECBAPyjzGT-HrhPmiijXns5lg2ZYa6uj6VvPpbGXd8U4YtG94SSVrE1eygmmZ2Xp-4CCkJCI6J7PsJYj0jcyh4IZOf6mlx-TVnCWhR-EcBpZ6JA.png",
                        UrlSocial = "https://www.facebook.com"
                    });
                }
                await context.Sponsors.AddRangeAsync(sponsors);
                await context.SaveChangesAsync();
            }

        }
    }
}
