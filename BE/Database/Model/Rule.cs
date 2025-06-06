using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Database.Model
{
    public class Rule
    {
        public int Id { get; set; }
        public string Title { get; set; }
        public string Content { get; set; }
        [Url]
        public string? Image1 { get; set; }
        [Url]
        public string? Image2 { get; set; }

        public int BlogCategoryId { get; set; }
        public BlogCategory? BlogCategory { get; set; }
    }
}
