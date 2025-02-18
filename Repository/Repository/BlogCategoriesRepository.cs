using Database.DTO.Response;
using Database.Model;
using Database.Model.Dbcontext;
using Microsoft.EntityFrameworkCore;
using Repository.Repository.Interfeace;

namespace Repository.Repository
{
    public class BlogCategoriesRepository : BaseRepository<BlogCategory>, IBlogCategoriesRepository
    {
        private readonly PickerBallDbcontext _context;

        public BlogCategoriesRepository(PickerBallDbcontext context) : base(context)
        {
            _context = context;
        }

        public async Task<PagingResult<BlogCategory>> PagingBlogCategories(int? currentPage, int? pageSize)
        {
            PagingResult<BlogCategory> result = new PagingResult<BlogCategory>();
            int totalCount = _context.BlogCategories.Count();
            int totalPages;
            List<BlogCategory> data;
            if (currentPage.HasValue && pageSize.HasValue)
            {
                data = await _context.BlogCategories.Skip((currentPage.Value - 1) * pageSize.Value).Take(pageSize.Value).ToListAsync();
                totalPages = (int)Math.Ceiling((double)totalCount / (int)pageSize);
            }
            else
            {
                data = await _context.BlogCategories.Take(10).ToListAsync();
                totalPages = (int)Math.Ceiling((double)totalCount / 10);
            }
            result.TotalPages = totalPages;
            result.TotalCount = totalCount;
            result.Results = data;
            result.PageSize = pageSize ?? 10;
            result.CurrentPage = currentPage ?? 1;
            return result;
        }
    }
}
