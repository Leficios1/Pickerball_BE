using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Database.DTO.PayOsDTO
{
    public class PayOsSettings
    {
        public string ClientId { get; set; }
        public string ApiKey { get; set; }
        public string ChecksumKey { get; set; }
        public string BaseUrl { get; set; }
    }
}
