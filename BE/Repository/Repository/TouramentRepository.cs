using Database.DTO.Response;
using Database.Model;
using Database.Model.Dbcontext;
using Microsoft.EntityFrameworkCore;
using Repository.Repository.Interfeace;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Repository.Repository
{
    public class TouramentRepository : BaseRepository<Tournaments>, ITouramentRepository
    {
        private readonly PickerBallDbcontext _context;

        public TouramentRepository(PickerBallDbcontext context) : base(context)
        {
            _context = context;
        }

        public Task<Tournaments> CreateTournament(Tournaments dto)
        {
            throw new NotImplementedException();
        }

        public Task<Tournaments> DeleteTournament(int id)
        {
            throw new NotImplementedException();
        }

        public async Task<List<Tournaments>> GetAllTournament()
        {
            return await _context.Tournaments.ToListAsync();
        }

        public Task<Tournaments> GetTournament(int id)
        {
            throw new NotImplementedException();
        }

        public Task<Tournaments> UpdateTournament(Tournaments dto)
        {
            throw new NotImplementedException();
        }
    }
}
