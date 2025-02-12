namespace Database.DTO.Request
{
    public class TeamRequestDTO
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public int? CaptainId { get; set; } // Người tạo team
        public int MatchingId { get; set; }
    }
}
