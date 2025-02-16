namespace Database.DTO.Response;
public class TeamMemberDTO
{
    public int Id { get; set; }
    public int? PlayerId { get; set; }
    public int? TeamId { get; set; }
    public DateTime? JoinedAt { get; set; }
}
