using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Database.DTO.Response
{
    public class PagingResult<T>
    {

        public int TotalCount { get; set; }
        public int PageSize { get; set; }
        public int CurrentPage { get; set; }
        public int TotalPages { get; set; }
        public List<T>? Results { get; set; }

        public PagingResult(int totalCount, int pageSize, int currentPage, int totalPages, bool hasNext, bool hasPrevious, List<T>? results)
        {
            TotalCount = totalCount;
            PageSize = pageSize;
            CurrentPage = currentPage;
            TotalPages = totalPages;
            Results = results;
        }

        public PagingResult()
        {
        }
    }
}
