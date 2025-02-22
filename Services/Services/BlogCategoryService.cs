using Database.DTO.Response;
using Database.Model;
using Repository.Repository.Interfeace;
using Services.Services.Interface;
using System.Net;

namespace Services.Services
{
    public class BlogCategoryService : IBlogCategory
    {
        private readonly IBlogCategoriesRepository _blogCategoriesRepository;
        public BlogCategoryService(IBlogCategoriesRepository blogCategoriesRepository)
        {
            _blogCategoriesRepository = blogCategoriesRepository;
        }

        public async Task<StatusResponse<BlogCategory>> CreateBlogCategory(BlogCategory BlogCategory)
        {
            StatusResponse<BlogCategory> response = new StatusResponse<BlogCategory>();
            try
            {
                await _blogCategoriesRepository.AddAsync(BlogCategory);
                await _blogCategoriesRepository.SaveChangesAsync();

                response.Data = BlogCategory;
                response.statusCode = HttpStatusCode.OK;
                response.Message = "Blog Category created successfully!";
            }
            catch (Exception ex)
            {
                response.statusCode = HttpStatusCode.InternalServerError;
                response.Message = ex.Message;
            }
            return response;
        }

        public async Task<StatusResponse<bool>> DeleteBlogCategory(int blogCategoryId)
        {
            StatusResponse<bool> response = new StatusResponse<bool>();
            try
            {
                var blogCategory = await _blogCategoriesRepository.GetById(blogCategoryId);
                if (blogCategory == null)
                {
                    response.statusCode = HttpStatusCode.NotFound;
                    response.Message = "Blog Category not found!";
                }
                else
                {
                    _blogCategoriesRepository.Delete(blogCategory);
                    await _blogCategoriesRepository.SaveChangesAsync();

                    response.Data = true;
                    response.statusCode = HttpStatusCode.OK;
                    response.Message = "Blog Category deleted successfully!";
                }
            }
            catch (Exception ex)
            {
                response.statusCode = HttpStatusCode.InternalServerError;
                response.Message = ex.Message;
            }
            return response;
        }

        public async Task<StatusResponse<PagingResult<BlogCategory>>> PaginglBlogCategories(int? currentPage, int? pageSize)
        {
            var response = new StatusResponse<PagingResult<BlogCategory>>();
            try
            {
                var blogCategories = await _blogCategoriesRepository.PagingBlogCategories(currentPage, pageSize);

                response.Data = blogCategories;
                response.statusCode = HttpStatusCode.OK;
                response.Message = "Blog Categories retrieved successfully!";
                return response;
            }
            catch (Exception ex)
            {
                response.statusCode = HttpStatusCode.InternalServerError;
                response.Message = ex.Message;
                return response;
            }
        }

        public async Task<StatusResponse<BlogCategory>> GetBlogCategoryById(int blogCategoryId)
        {
            var response = new StatusResponse<BlogCategory>();
            try
            {
                var data = await _blogCategoriesRepository.GetById(blogCategoryId);
                if (data == null)
                {
                    response.statusCode = HttpStatusCode.NotFound;
                    response.Message = "Blog Categories not found!";
                    return response;
                }

                response.Data = data;
                response.statusCode = HttpStatusCode.OK;
                response.Message = "Get Blog Categories by id success!";

            }
            catch (Exception e)
            {
                response.statusCode = HttpStatusCode.InternalServerError;
                response.Message = e.Message;
            }
            return response;
        }

        public async Task<StatusResponse<BlogCategory>> UpdateBlogCategory(BlogCategory BlogCategory)
        {
            StatusResponse<BlogCategory> response = new StatusResponse<BlogCategory>();
            try
            {
                _blogCategoriesRepository.Update(BlogCategory);
                await _blogCategoriesRepository.SaveChangesAsync();

                response.Data = BlogCategory;
                response.statusCode = HttpStatusCode.OK;
                response.Message = "Blog Category created successfully!";
            }
            catch (Exception ex)
            {
                response.statusCode = HttpStatusCode.InternalServerError;
                response.Message = ex.Message;
            }
            return response;
        }
    }
}
