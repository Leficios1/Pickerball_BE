namespace Database.DTO.Request
{
    public class RuleCreateDTO
    {
        public string Title { get; set; } = string.Empty;
        public string Content { get; set; } = string.Empty;
        public int BlogCategoryId { get; set; }
    }
}
