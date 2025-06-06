using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Database.Model
{
    public class Achievement
    {
        public int Id { get; set; }

        public int UserId { get; set; }
        public User User { get; set; }

        public string Title { get; set; }
        public string Description { get; set; }
        public DateTime AwardedAt { get; set; }
    }
}
