﻿using Database.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Repository.Repository.Interfeace
{
    public interface ITournamentRegistrationRepository : IBaseRepository<TournamentRegistration>
    {
        Task<List<TournamentRegistration>> getByTournamentId(int TournamentId);
        Task<List<TournamentRegistration>> getAllByPlayerId(int PlayerId);
        Task<TournamentRegistration> getByPlayerId(int PlayerId);
        Task<TournamentRegistration> getByPlayerIdAndTournamentId(int PlayerId, int TournamentId);
    }
}
