using Database.DTO.Request;
using Database.DTO.Response;
using Database.Model;

namespace Services.Services.Interface
{
    public interface IBlogCategory
    {
        public Task<StatusResponse<PagingResult<BlogCategoryDTO>>> PaginglBlogCategories(int? currentPage, int? pageSize);
        public Task<StatusResponse<BlogCategoryDTO>> GetBlogCategoryById(int blogCategoryId);
        public Task<StatusResponse<BlogCategoryDTO>> UpdateBlogCategory(BlogCategoryDTO BlogCategory);
        public Task<StatusResponse<BlogCategoryDTO>> CreateBlogCategory(BlogCategoryCreateDTO BlogCategory);
        public Task<StatusResponse<bool>> DeleteBlogCategory(int blogCategoryId);
    }
}
