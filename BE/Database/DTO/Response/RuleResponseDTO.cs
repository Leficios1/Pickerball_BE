namespace Database.DTO.Response
{
    public class RuleResponseDTO
    {
        public int Id { get; set; }
        public string Title { get; set; } = string.Empty;
        public string Content { get; set; } = string.Empty;
        public string? Image1 { get; set; }
        public string? Image2 { get; set; }

        public int BlogCategoryId { get; set; }
    }
}
