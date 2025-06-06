using Database.DTO.Request;
using Database.Model;
using Microsoft.AspNetCore.Mvc;
using Services.Services.Interface;

namespace PickerBall_BE.Controllers
{
    [Route("api/blog-categories")]
    [ApiController]
    public class BlogCategoriesController : ControllerBase
    {
        private readonly IBlogCategory _blogCategory;
        public BlogCategoriesController(IBlogCategory blogCategory)
        {
            _blogCategory = blogCategory;
        }
        [HttpGet]
        public async Task<IActionResult> PagingBlogCatories(int? currentPage, int? pageSize)
        {
            var response = await _blogCategory.PaginglBlogCategories(currentPage, pageSize);
            return StatusCode((int)response.statusCode, new { data = response.Data, message = response.Message });
        }
        [HttpGet("get-by-id")]
        public async Task<IActionResult> GetBlogCategoryById(int blogCategoryId)
        {
            var response = await _blogCategory.GetBlogCategoryById(blogCategoryId);
            return StatusCode((int)response.statusCode, new { data = response.Data, message = response.Message });
        }
        [HttpPost("create")]
        public async Task<IActionResult> CreateBlogCategory(BlogCategoryCreateDTO blogCategory)
        {
            var response = await _blogCategory.CreateBlogCategory(blogCategory);
            return StatusCode((int)response.statusCode, new { data = response.Data, message = response.Message });
        }
        [HttpPut("edit")]
        public async Task<IActionResult> UpdateBlogCategory(BlogCategoryDTO blogCategory)
        {
            var response = await _blogCategory.UpdateBlogCategory(blogCategory);
            return StatusCode((int)response.statusCode, new { data = response.Data, message = response.Message });
        }
        [HttpDelete("delete")]
        public async Task<IActionResult> DeleteBlogCategory(int blogCategoryId)
        {
            var response = await _blogCategory.DeleteBlogCategory(blogCategoryId);
            return StatusCode((int)response.statusCode, new { data = response.Data, message = response.Message });
        }
    }
}
