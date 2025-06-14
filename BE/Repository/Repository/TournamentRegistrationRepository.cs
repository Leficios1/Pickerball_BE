﻿using Database.Model;
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
    public class TournamentRegistrationRepository : BaseRepository<TournamentRegistration>, ITournamentRegistrationRepository
    {
        private readonly PickerBallDbcontext _context;
        public TournamentRegistrationRepository(PickerBallDbcontext context) : base(context)
        {
            _context = context;
        }

        public async Task<List<TournamentRegistration>> getAllByPlayerId(int PlayerId)
        {
            return await _context.TournamentRegistrations.Where(x => x.PlayerId == PlayerId).ToListAsync();
        }

        public async Task<TournamentRegistration> getByPlayerId(int PlayerId)
        {
            return await _context.TournamentRegistrations.SingleOrDefaultAsync(x => x.PlayerId == PlayerId);
        }

        public async Task<TournamentRegistration> getByPlayerIdAndTournamentId(int PlayerId, int TournamentId)
        {
            return await _context.TournamentRegistrations.SingleOrDefaultAsync(x => x.PlayerId == PlayerId && x.TournamentId == TournamentId);
        }

        public async Task<List<TournamentRegistration>> getByTournamentId(int TournamentId)
        {
            return await _context.TournamentRegistrations.Where(x => x.TournamentId == TournamentId).ToListAsync();
        }
    }
}
