using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.Json.Serialization;
using System.Threading.Tasks;

namespace Database.DTO.Request
{
    public class BlogCategoryDTO
    {
        public int Id { get; set; }
        public string Name { get; set; } = null!;
    }
}
