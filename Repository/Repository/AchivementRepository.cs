using Database.Model;
using Database.Model.Dbcontext;
using Repository.Repository.Interfeace;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Repository.Repository
{
    public class AchivementRepository : BaseRepository<Achievement>, IAchivementRepository
    {
        private readonly PickerBallDbcontext _context;

        public AchivementRepository(PickerBallDbcontext context) : base(context)
        {
            _context = context;
        }
    }
}
