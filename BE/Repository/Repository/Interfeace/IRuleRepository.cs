using Database.DTO.Response;
using Database.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Repository.Repository.Interfeace
{
    public interface IRuleRepository : IBaseRepository<Rule>
    {
        Task<PagingResult<Rule>> PagingRule(int? currentPage, int? pageSize);
    }
}
