using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Database.DTO.Response
{
    public class VerifyEmailResponseDTO
    {
        public string Email { get; set; }
        public decimal OTP { get; set; }
    }
}
