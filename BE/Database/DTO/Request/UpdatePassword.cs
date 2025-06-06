using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Database.DTO.Request
{
    public class UpdatePassword
    {
        public int UserId {  get; set; }
        public string NewPassword { get; set; }
    }
}
