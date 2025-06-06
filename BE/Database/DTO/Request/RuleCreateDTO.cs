namespace Database.DTO.Request
{
    public class RuleCreateDTO
    {
        public string Title { get; set; } = string.Empty;
        public string Content { get; set; } = string.Empty;
        public int BlogCategoryId { get; set; }
        public string? Image1 { get; set; }
        public string? Image2 { get; set; }
    }
}
