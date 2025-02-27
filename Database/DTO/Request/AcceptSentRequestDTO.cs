using Database.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Database.DTO.Request
{
    public class AcceptSentRequestDTO
    {
        public int RequestId { get; set; }
        public int UserAcceptId { get; set; }
        public SendRequestStatus Status { get; set; }
    }
}
