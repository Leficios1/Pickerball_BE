using System;
using System.Collections.Generic;
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

        public int BlogCategoryId { get; set; }
        public BlogCategory? BlogCategory { get; set; }
    }
}
