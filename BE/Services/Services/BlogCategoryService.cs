using AutoMapper;
using Database.DTO.Request;
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
        private readonly IMapper _mapper;
        public BlogCategoryService(IBlogCategoriesRepository blogCategoriesRepository, IMapper mapper)
        {
            _blogCategoriesRepository = blogCategoriesRepository;
            _mapper = mapper;
        }

        public async Task<StatusResponse<BlogCategoryDTO>> CreateBlogCategory(BlogCategoryCreateDTO BlogCategory)
        {
            StatusResponse<BlogCategoryDTO> response = new StatusResponse<BlogCategoryDTO>();
            try
            {
                var category = _mapper.Map<BlogCategory>(BlogCategory);
                await _blogCategoriesRepository.AddAsync(category);
                await _blogCategoriesRepository.SaveChangesAsync();

                var categoryResponse = _mapper.Map<BlogCategoryDTO>(category);
                response.Data = categoryResponse;
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
                var blogCategory = await _blogCategoriesRepository.GetBlogCategoryById(blogCategoryId);
                if (blogCategory == null)
                {
                    response.statusCode = HttpStatusCode.NotFound;
                    response.Message = "Blog Category not found!";
                }
                else
                {
                    if(blogCategory.Rules != null && blogCategory.Rules.Count > 0)
                    {
                        response.statusCode = HttpStatusCode.BadRequest;
                        response.Message = "Blog Category has many contents!";
                        return response;
                    }
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

        public async Task<StatusResponse<PagingResult<BlogCategoryDTO>>> PaginglBlogCategories(int? currentPage, int? pageSize)
        {
            var response = new StatusResponse<PagingResult<BlogCategoryDTO>>();
            try
            {
                var blogCategories = await _blogCategoriesRepository.PagingBlogCategories(currentPage, pageSize);
                var dataResponse = _mapper.Map<PagingResult<BlogCategoryDTO>>(blogCategories);

                response.Data = dataResponse;
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

        public async Task<StatusResponse<BlogCategoryDTO>> GetBlogCategoryById(int blogCategoryId)
        {
            var response = new StatusResponse<BlogCategoryDTO>();
            try
            {
                var data = await _blogCategoriesRepository.GetById(blogCategoryId);
                if (data == null)
                {
                    response.statusCode = HttpStatusCode.NotFound;
                    response.Message = "Blog Categories not found!";
                    return response;
                }

                response.Data = _mapper.Map<BlogCategoryDTO>(data);
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

        public async Task<StatusResponse<BlogCategoryDTO>> UpdateBlogCategory(BlogCategoryDTO BlogCategory)
        {
            StatusResponse<BlogCategoryDTO> response = new StatusResponse<BlogCategoryDTO>();
            try
            {
                var category = _mapper.Map<BlogCategory>(BlogCategory);
                _blogCategoriesRepository.Update(category);
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
