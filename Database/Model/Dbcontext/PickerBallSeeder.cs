using Database.Model;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;

namespace Database.Model.Dbcontext
{
    public static class PickerBallSeeder
    {
        public static void Seed(this ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Role>().HasData(
                new Role
                {
                    RoleId = 1,
                    RoleName = "Player"
                },
                new Role
                {
                    RoleId = 2,
                    RoleName = "Admin"
                },
                new Role
                {
                    RoleId = 3,
                    RoleName = "Sponsor"
                },
                new Role
                {
                    RoleId = 4,
                    RoleName = "Referee"
                },
                new Role
                {
                    RoleId = 5,
                    RoleName = "User"
                },
                new Role
                {
                    RoleId = 6,
                    RoleName = "Staff"
                },
                new Role
                {
                    RoleId = 7,
                    RoleName = "=Admin Club"
                }
            );
            modelBuilder.Entity<RuleOfAward>().HasData(
                new RuleOfAward
                {
                    Id = 1,
                    Position = 1,
                    PercentOfPrize = 40
                },
                new RuleOfAward
                {
                    Id = 2,
                    Position = 2,
                    PercentOfPrize = 30
                },
                new RuleOfAward
                {
                    Id = 3,
                    Position = 3,
                    PercentOfPrize = 15
                },
                new RuleOfAward
                {
                    Id = 4,
                    Position = 4,
                    PercentOfPrize = 15
                }
            );
        }
    }
}

