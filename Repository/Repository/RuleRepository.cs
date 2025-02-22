using Database.DTO.Response;
using Database.Model;
using Database.Model.Dbcontext;
using Microsoft.EntityFrameworkCore;
using Repository.Repository.Interfeace;

namespace Repository.Repository
{
    public class RuleRepository : BaseRepository<Rule>, IRuleRepository
    {
        private readonly PickerBallDbcontext _context;

        public RuleRepository(PickerBallDbcontext context) : base(context)
        {
            _context = context;
        }

        public async Task<PagingResult<Rule>> PagingRule(int? currentPage, int? pageSize)
        {
            PagingResult<Rule> result = new PagingResult<Rule>();
            int totalCount = _context.Rules.Count();
            int totalPages;
            List<Rule> data;
            if (currentPage.HasValue && pageSize.HasValue)
            {
                data = await _context.Rules.Skip((currentPage.Value - 1) * pageSize.Value).Take(pageSize.Value).ToListAsync();
                totalPages = (int)Math.Ceiling((double)totalCount / (int)pageSize);
            }
            else
            {
                data = await _context.Rules.Take(10).ToListAsync();
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
