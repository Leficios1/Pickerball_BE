using Database.DTO.Response;
using Database.Model;

namespace Repository.Repository.Interfeace
{
    public interface IBlogCategoriesRepository : IBaseRepository<BlogCategory>
    {
        Task<PagingResult<BlogCategory>> PagingBlogCategories(int? currentPage, int? pageSize);
    }
}
