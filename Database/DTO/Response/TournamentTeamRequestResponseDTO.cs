using Database.Model;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Database.DTO.Response
{
    public class TournamentTeamRequestResponseDTO
    {
        public int Id { get; set; }

        public int RegistrationId { get; set; }

        public int RequesterId { get; set; }  // Người gửi lời mời
        public string? RequesterName { get; set; } // Tên người gửi lời mời

        public int PartnerId { get; set; }  // Người nhận lời mời
        public int? TournamentId { get; set; } // ID giải đấu
        public string? TournamentName { get; set; } // Tên giải đấu

        public TournamentRequestStatus Status { get; set; } // Pending, Accepted, Rejected

        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    }
}
