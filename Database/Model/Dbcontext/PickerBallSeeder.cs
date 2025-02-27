using Database.Model;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
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
                    RoleName = "Refree"
                },
                new Role
                {
                    RoleId = 5,
                    RoleName = "User"
                }
            );
        }
    }
}
