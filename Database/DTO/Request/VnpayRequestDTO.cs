using System.ComponentModel.DataAnnotations;

namespace Database.DTO.Request
{
    public class VnpayRequestDTO
    {
        public int userId { get; set; }
        [Url]
        public string urlResponse { get; set; } = null!;
    }
}
