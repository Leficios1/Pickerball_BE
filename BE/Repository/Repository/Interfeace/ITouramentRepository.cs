using Database.DTO.Request;
using Database.DTO.Response;
using Database.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Repository.Repository.Interfeace
{
    public interface ITouramentRepository : IBaseRepository<Tournaments>
    {
        //public Task<StatusResponse<Tournaments>> CreateTournament(Tournaments dto);
        public Task<Tournaments> UpdateTournament(Tournaments dto);
        public Task<Tournaments> DeleteTournament(int id);
        public Task<List<Tournaments>> GetAllTournament();

    }
}
