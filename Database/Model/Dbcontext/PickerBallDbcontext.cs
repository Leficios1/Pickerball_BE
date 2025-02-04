using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;

namespace Database.Model.Dbcontext
{
    public class PickerBallDbcontext : DbContext
    {
        public PickerBallDbcontext(DbContextOptions<PickerBallDbcontext> options) : base(options)
        {
        }

        public DbSet<User> Users { get; set; }
        public DbSet<Player> Player { get; set; }
        public DbSet<Sponsor> Sponsors { get; set; }
        public DbSet<Room> Room { get; set; }
        public DbSet<RoomPlayers> RoomPlayers { get; set; }
        public DbSet<Friends> Friends { get; set; }
        public DbSet<TournamentProgress> TournamentProgresses { get; set; }
        public DbSet<Tournaments> Tournaments { get; set; }
        public DbSet<TournamentRegistration> TournamentRegistrations { get; set; }
        public DbSet<Matches> Matches { get; set; }
        //public DbSet<mat> MatchTeams { get; set; }
        public DbSet<Team> Teams { get; set; }
        public DbSet<TeamMembers> TeamMembers { get; set; }
        public DbSet<Venues> Venues { get; set; }
        //public DbSet<TournamentVenues> TournamentVenues { get; set; }
        public DbSet<Ranking> Rankings { get; set; }
        public DbSet<Achievement> Achievements { get; set; }
        public DbSet<Rule> Rules { get; set; }
        public DbSet<BlogCategory> RuleCategories { get; set; }
        public DbSet<Payments> Payments { get; set; }
        public DbSet<Notification> Notifications { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            // ===================== [ User System ] =====================
            modelBuilder.Entity<Player>()
                .HasOne(p => p.User)
                .WithOne(u => u.Player)
                .HasForeignKey<Player>(p => p.UserId)
                .OnDelete(DeleteBehavior.Cascade);

            modelBuilder.Entity<Sponsor>()
                .HasOne(s => s.User)
                .WithOne(u => u.Sponsor)
                .HasForeignKey<Sponsor>(s => s.UserId)
                .OnDelete(DeleteBehavior.Cascade);

            // ===================== [ Friends System ] =====================
            modelBuilder.Entity<Friends>()
                .HasOne(f => f.User1)
                .WithMany()
                .HasForeignKey(f => f.User1Id)
                .OnDelete(DeleteBehavior.NoAction);

            modelBuilder.Entity<Friends>()
                .HasOne(f => f.User2)
                .WithMany()
                .HasForeignKey(f => f.User2Id)
                .OnDelete(DeleteBehavior.NoAction);

            // ===================== [ Tournament System ] =====================
            modelBuilder.Entity<Tournaments>()
                .HasOne(t => t.Organizer)
                .WithMany()
                .HasForeignKey(t => t.OrganizerId)
                .OnDelete(DeleteBehavior.NoAction);

            modelBuilder.Entity<TournamentRegistration>()
                .HasOne(tr => tr.Player)
                .WithMany(p => p.TournamentRegistrations)
                .HasForeignKey(tr => tr.PlayerId)
                .OnDelete(DeleteBehavior.NoAction);

            modelBuilder.Entity<TournamentProgress>()
                .HasOne(tp => tp.TournamentRegistration)
                .WithMany()
                .HasForeignKey(tp => tp.TournamentRegistrationId)
                .OnDelete(DeleteBehavior.NoAction);

            // ===================== [ Ranking & Achievements ] =====================
            modelBuilder.Entity<Ranking>()
                .HasOne(r => r.Tournament)
                .WithMany(t => t.Rankings)
                .HasForeignKey(r => r.TournamentId)
                .OnDelete(DeleteBehavior.Cascade);

            modelBuilder.Entity<Ranking>()
                .HasOne(r => r.Player)
                .WithMany(p => p.Rankings)
                .HasForeignKey(r => r.PlayerId)
                .OnDelete(DeleteBehavior.NoAction);

            // ===================== [ Match System ] =====================
            modelBuilder.Entity<Matches>()
                .HasOne(m => m.Tournament)
                .WithMany(t => t.Matches)
                .HasForeignKey(m => m.TournamentId)
                .OnDelete(DeleteBehavior.Cascade);

            modelBuilder.Entity<Matches>()
                 .HasOne(m => m.Player1)
                 .WithMany()
                 .HasForeignKey(m => m.Player1Id)
                 .OnDelete(DeleteBehavior.NoAction);

            modelBuilder.Entity<Matches>()
                .HasOne(m => m.Player2)
                .WithMany()
                .HasForeignKey(m => m.Player2Id)
                .OnDelete(DeleteBehavior.NoAction);

            modelBuilder.Entity<Matches>()
                .HasOne(m => m.Team1)
                .WithMany()
                .HasForeignKey(m => m.Team1Id)
                .OnDelete(DeleteBehavior.NoAction);

            modelBuilder.Entity<Matches>()
                .HasOne(m => m.Team2)
                .WithMany()
                .HasForeignKey(m => m.Team2Id)
                .OnDelete(DeleteBehavior.NoAction);

            modelBuilder.Entity<Matches>()
                .HasOne(m => m.Venue)
                .WithMany(v => v.Matches)
                .HasForeignKey(m => m.VenueId)
                .OnDelete(DeleteBehavior.Cascade);

            // ===================== [ Match Team Members ] =====================
            //modelBuilder.Entity<MatchTeamMember>()
            //    .HasOne(mtm => mtm.Match)
            //    .WithMany()
            //    .HasForeignKey(mtm => mtm.MatchId)
            //    .OnDelete(DeleteBehavior.Cascade);

            //modelBuilder.Entity<MatchTeamMember>()
            //    .HasOne(mtm => mtm.Team)
            //    .WithMany()
            //    .HasForeignKey(mtm => mtm.TeamId)
            //    .OnDelete(DeleteBehavior.Cascade);

            //modelBuilder.Entity<MatchTeamMember>()
            //    .HasOne(mtm => mtm.Player)
            //    .WithMany()
            //    .HasForeignKey(mtm => mtm.PlayerId)
            //    .OnDelete(DeleteBehavior.Cascade);

            // ===================== [ Room System ] =====================
            modelBuilder.Entity<Room>()
                .HasOne(r => r.Creator)
                .WithMany()
                .HasForeignKey(r => r.CreatorId)
                .OnDelete(DeleteBehavior.NoAction);

            modelBuilder.Entity<RoomPlayers>()
                .HasOne(rp => rp.Room)
                .WithMany()
                .HasForeignKey(rp => rp.RoomId)
                .OnDelete(DeleteBehavior.NoAction);

            modelBuilder.Entity<RoomPlayers>()
                .HasOne(rp => rp.Player)
                .WithMany()
                .HasForeignKey(rp => rp.PlayerId)
                .OnDelete(DeleteBehavior.NoAction);

            // ===================== [ Teams & Members ] =====================
            modelBuilder.Entity<TeamMembers>()
                .HasOne(tm => tm.Playermember)
                .WithMany()
                .HasForeignKey(tm => tm.PlayerId)
                .OnDelete(DeleteBehavior.NoAction);

            modelBuilder.Entity<TeamMembers>()
                .HasOne(tm => tm.Team)
                .WithMany(t => t.Members)
                .HasForeignKey(tm => tm.TeamId)
                .OnDelete(DeleteBehavior.NoAction);

            // ===================== [ Payment System ] =====================
            modelBuilder.Entity<Payments>()
                   .HasOne(p => p.Sponsor)
                   .WithMany(s => s.Payments)
                   .HasForeignKey(p => p.SponsorId)
                   .OnDelete(DeleteBehavior.NoAction);

            modelBuilder.Entity<Payments>()
                .HasOne(p => p.Tournament)
                .WithMany(t => t.Payments)
                .HasForeignKey(p => p.TournamentId)
                .OnDelete(DeleteBehavior.NoAction);

            // ===================== [ Rules System ] =====================
            modelBuilder.Entity<Rule>()
                .HasOne(r => r.RuleCategory)
                .WithMany(rc => rc.Rules)
                .HasForeignKey(r => r.RuleCategoryId)
                .OnDelete(DeleteBehavior.NoAction);
        }

    }
}