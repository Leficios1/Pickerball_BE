using Database.DTO.Response;
using Database.Model;

namespace Services.Services.Interface
{
    public interface IBlogCategory
    {
        public Task<StatusResponse<PagingResult<BlogCategory>>> PaginglBlogCategories(int? currentPage, int? pageSize);
        public Task<StatusResponse<BlogCategory>> GetBlogCategoryById(int blogCategoryId);
        public Task<StatusResponse<BlogCategory>> UpdateBlogCategory(BlogCategory BlogCategory);
        public Task<StatusResponse<BlogCategory>> CreateBlogCategory(BlogCategory BlogCategory);
        public Task<StatusResponse<bool>> DeleteBlogCategory(int blogCategoryId);
    }
}
