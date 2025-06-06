using Database.Model;
using System.Collections.Generic;
using System.Threading.Tasks;
using Database.DTO.Request;
using Repository.Repository.Interfeace;

namespace Repository.Repository.Interface
{
    public interface IRefreeRepository : IBaseRepository<Refree>
    {
        Task<Refree> CreateRefreeAsync(CreateRefreeDTO refreeDto);
        Task<List<Refree>> GetByRefreeCode(string refreeCode);
        Task<List<Refree>> GetAllRefreesAsync();
    }
}
