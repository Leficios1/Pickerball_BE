using Database.Model;
using Microsoft.EntityFrameworkCore;
using Repository.Repository.Interface;
using Repository.Repository.Interfeace;
using Services.Services.Interface;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Services.Services
{
    public class MyScheduledService : IMyScheduledService
    {
        private readonly ITouramentRepository _touramentRepository;
        private readonly IMatchesRepository _matchesRepository;
        private readonly ITournamentRegistrationRepository _tournamentRegistrationRepository;
        private readonly ITournamentTeamRequestRepository _tournamentTeamRequestRepository;

        public MyScheduledService(ITouramentRepository touramentRepository, IMatchesRepository matchesRepository, ITournamentRegistrationRepository tournamentRegistrationRepository, ITournamentTeamRequestRepository tournamentTeamRequestRepository)
        {
            _touramentRepository = touramentRepository;
            _matchesRepository = matchesRepository;
            _tournamentRegistrationRepository = tournamentRegistrationRepository;
            _tournamentTeamRequestRepository = tournamentTeamRequestRepository;
        }

        public async Task DoDailyTaskAsync()
        {
            try
            {
                var tournamentList = await _touramentRepository.Get().Where(x => x.EndDate < DateTime.UtcNow && x.Status == "Scheduled").ToListAsync();
                if (tournamentList.Any())
                {
                    foreach (var tournamentData in tournamentList)
                    {
                        tournamentData.Status = "Disable";
                        _touramentRepository.Update(tournamentData);
                    }
                    await _touramentRepository.SaveChangesAsync();
                }
                var matchList = await _matchesRepository.Get().Where(x => x.MatchDate < DateTime.UtcNow.AddDays(3) && x.MatchCategory == MatchCategory.Competitive).ToListAsync();
                if (matchList.Any())
                {
                    foreach (var match in matchList)
                    {
                        match.Status = MatchStatus.Disable;
                        _matchesRepository.Update(match);
                    }
                    await _matchesRepository.SaveChangesAsync();
                }
                var registrationList = await _tournamentRegistrationRepository.Get().Where(x => x.IsApproved == TouramentregistrationStatus.Pending).ToArrayAsync();
                if (registrationList.Any())
                {
                    foreach (var registration in registrationList)
                    {
                        _tournamentRegistrationRepository.Delete(registration);
                    }
                    await _tournamentRegistrationRepository.SaveChangesAsync();
                }

            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message, ex);
            }
        }
    }
}
