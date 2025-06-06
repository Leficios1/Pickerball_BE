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
    public class PaymentRepository : BaseRepository<Payments>, IPaymentRepository 
    {
        private readonly PickerBallDbcontext _context;

        public PaymentRepository(PickerBallDbcontext context) : base(context)
        {
            _context = context;
        }

        public async Task<Payments> GetPaymentByUserId(int userId)
        {
            return await _context.Payments.Where(x => x.UserId == userId).SingleOrDefaultAsync();
        }
    }
}
