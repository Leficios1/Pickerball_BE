using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Database.DTO.Response
{
    public class RefershTokenResponseDTO
    {
        public string RefreshToken { get; set; } = null!;
        public string TokenString { get; set; } = null!;
    }
}
