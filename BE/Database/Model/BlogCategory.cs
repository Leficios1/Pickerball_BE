using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Database.Model
{
    public class BlogCategory
    {
        public int Id { get; set; }
        public string Name { get; set; }

        public ICollection<Rule> Rules { get; set; }
    }
}
