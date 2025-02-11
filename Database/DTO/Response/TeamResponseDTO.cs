namespace Database.DTO.Response
{
    public class TeamResponseDTO
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public int? CaptainId { get; set; } // Người tạo team
        public int MatchingId { get; set; }
        public List<TeamMemberDTO> Members { get; set; }
    }
}
