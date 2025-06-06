namespace Database.DTO.Request
{
    public class CreateRefreeDTO
    {
        public int UserId { get; set; }
        public string? RefreeCode { get; set; }
        public string? RefreeLevel { get; set; }
        public string? RefreeNote { get; set; }
    }
    
    public class UpdateRefreeDTO
    {
        public int? UserId { get; set; }
        public string? RefreeCode { get; set; }
        public string? RefreeLevel { get; set; }
        public string? RefreeNote { get; set; }
        public bool? isAccept { get; set; }
    }
}
