using Database.Model;
using Database.Model.Dbcontext;
using Repository.Repository.Interface;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Database.DTO.Request;
using Microsoft.EntityFrameworkCore;

namespace Repository.Repository
{
    public class RefreeRepository : BaseRepository<Refree>, IRefreeRepository
    {
        private readonly PickerBallDbcontext _context;

        public RefreeRepository(PickerBallDbcontext context) : base(context)
        {
            _context = context;
        }

        public async Task<Refree> CreateRefreeAsync(CreateRefreeDTO refreeDto)
        {
            var refree = new Refree
            {
                RefreeId = refreeDto.UserId,
                RefreeCode = refreeDto.RefreeCode,
                RefreeLevel = refreeDto.RefreeLevel ?? "",
                RefreeNote = refreeDto.RefreeNote ?? "",
                isAccept = false,
                CreatedAt = DateTime.UtcNow,
                LastUpdatedAt = DateTime.UtcNow
            };

            await _context.AddAsync(refree);
            await _context.SaveChangesAsync();
            return refree;
        }

        public async Task<List<Refree>> GetByRefreeCode(string refreeCode)
        {
            return await _context.Refree
                .Where(r => r.RefreeCode == refreeCode)
                .Include(r => r.User)
                .OrderByDescending(r => r.CreatedAt)
                .ToListAsync();
        }

        public async Task<List<Refree>> GetAllRefreesAsync()
        {
            return await _context.Refree
                .Include(r => r.User)
                .OrderByDescending(r => r.CreatedAt)
                .ToListAsync();
        }
    }
}
