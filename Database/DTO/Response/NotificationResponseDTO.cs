using Database.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Database.DTO.Response
{
    public class NotificationResponseDTO
    {
        public int Id { get; set; }
        public string Message { get; set; }
        public DateTime CreatedAt { get; set; }
        public bool IsRead { get; set; }
        public NotificationType? Type { get; set; }
        public int? ReferenceId { get; set; }
        public int? BonusId { get; set; } // Id tham chiếu đến bảng tương ứng

        // Thông tin gợi ý chuyển hướng
        public string? RedirectUrl { get; set; } // FE dùng để route
        public string? ExtraInfo { get; set; } // VD: Tên người gửi, tên giải đấu,...
    }
}
