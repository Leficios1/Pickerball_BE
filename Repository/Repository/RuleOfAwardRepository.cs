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
    public class RuleOfAwardRepository : BaseRepository<RuleOfAward> , IRuleOfAwardRepository
    {
        private readonly PickerBallDbcontext _dbcontext;

        public RuleOfAwardRepository(PickerBallDbcontext dbcontext) : base(dbcontext)
        {
            _dbcontext = dbcontext;
        }
    }
}
