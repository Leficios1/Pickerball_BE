using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace Database.Migrations
{
    /// <inheritdoc />
    public partial class UpdateDBSeeder : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "BlogCategories",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Name = table.Column<string>(type: "nvarchar(max)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_BlogCategories", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "Roles",
                columns: table => new
                {
                    RoleId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    RoleName = table.Column<string>(type: "nvarchar(max)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Roles", x => x.RoleId);
                });

            migrationBuilder.CreateTable(
                name: "RulesScores",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    MinDifference = table.Column<int>(type: "int", nullable: false),
                    MaxDifference = table.Column<int>(type: "int", nullable: false),
                    WinnerGain = table.Column<int>(type: "int", nullable: false),
                    LoseGain = table.Column<int>(type: "int", nullable: false),
                    CreateAt = table.Column<DateTime>(type: "datetime2", nullable: false),
                    UpdateAt = table.Column<DateTime>(type: "datetime2", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_RulesScores", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "transactionPayments",
                columns: table => new
                {
                    TransactionId = table.Column<string>(type: "nvarchar(450)", nullable: false),
                    BankTranNo = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    PayDate = table.Column<DateTime>(type: "datetime2", nullable: true),
                    OrderInfo = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    ResponseCode = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    TransactionStatus = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    CardType = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    TxnRef = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    Amount = table.Column<long>(type: "bigint", nullable: false),
                    BankCode = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    OrderId = table.Column<int>(type: "int", nullable: false),
                    UserId = table.Column<int>(type: "int", nullable: false),
                    Note = table.Column<string>(type: "nvarchar(max)", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_transactionPayments", x => x.TransactionId);
                });

            migrationBuilder.CreateTable(
                name: "Rules",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Title = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Content = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Image1 = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    Image2 = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    BlogCategoryId = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Rules", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Rules_BlogCategories_BlogCategoryId",
                        column: x => x.BlogCategoryId,
                        principalTable: "BlogCategories",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateTable(
                name: "Users",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    FirstName = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    LastName = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    SecondName = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    Email = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    PasswordHash = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    DateOfBirth = table.Column<DateTime>(type: "datetime2", nullable: true),
                    AvatarUrl = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    Gender = table.Column<string>(type: "nvarchar(10)", maxLength: 10, nullable: true),
                    PhoneNumber = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    Status = table.Column<bool>(type: "bit", nullable: false),
                    Reason = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    RoleId = table.Column<int>(type: "int", nullable: false),
                    RefreshToken = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    CreateAt = table.Column<DateTime>(type: "datetime2", nullable: true),
                    RefreshTokenExpiryTime = table.Column<DateTime>(type: "datetime2", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Users", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Users_Roles_RoleId",
                        column: x => x.RoleId,
                        principalTable: "Roles",
                        principalColumn: "RoleId",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Achievements",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    UserId = table.Column<int>(type: "int", nullable: false),
                    Title = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Description = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    AwardedAt = table.Column<DateTime>(type: "datetime2", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Achievements", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Achievements_Users_UserId",
                        column: x => x.UserId,
                        principalTable: "Users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Friends",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    User1Id = table.Column<int>(type: "int", nullable: false),
                    User2Id = table.Column<int>(type: "int", nullable: false),
                    Status = table.Column<int>(type: "int", nullable: false),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Friends", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Friends_Users_User1Id",
                        column: x => x.User1Id,
                        principalTable: "Users",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK_Friends_Users_User2Id",
                        column: x => x.User2Id,
                        principalTable: "Users",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateTable(
                name: "Notifications",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    UserId = table.Column<int>(type: "int", nullable: false),
                    Message = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false),
                    IsRead = table.Column<bool>(type: "bit", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Notifications", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Notifications_Users_UserId",
                        column: x => x.UserId,
                        principalTable: "Users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Player",
                columns: table => new
                {
                    PlayerId = table.Column<int>(type: "int", nullable: false),
                    Province = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    City = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    CCCD = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    TotalMatch = table.Column<int>(type: "int", nullable: false),
                    TotalWins = table.Column<int>(type: "int", nullable: false),
                    RankingPoint = table.Column<int>(type: "int", nullable: false),
                    ExperienceLevel = table.Column<int>(type: "int", nullable: false),
                    JoinedAt = table.Column<DateTime>(type: "datetime2", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Player", x => x.PlayerId);
                    table.ForeignKey(
                        name: "FK_Player_Users_PlayerId",
                        column: x => x.PlayerId,
                        principalTable: "Users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Refree",
                columns: table => new
                {
                    RefreeId = table.Column<int>(type: "int", nullable: false),
                    RefreeCode = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    RefreeLevel = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    RefreeNote = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false),
                    LastUpdatedAt = table.Column<DateTime>(type: "datetime2", nullable: false),
                    isAccept = table.Column<bool>(type: "bit", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Refree", x => x.RefreeId);
                    table.ForeignKey(
                        name: "FK_Refree_Users_RefreeId",
                        column: x => x.RefreeId,
                        principalTable: "Users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Sponsors",
                columns: table => new
                {
                    SponsorId = table.Column<int>(type: "int", nullable: false),
                    CompanyName = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    LogoUrl = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    UrlSocial = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    UrlSocial1 = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    ContactEmail = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Descreption = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    isAccept = table.Column<bool>(type: "bit", nullable: false),
                    JoinedAt = table.Column<DateTime>(type: "datetime2", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Sponsors", x => x.SponsorId);
                    table.ForeignKey(
                        name: "FK_Sponsors_Users_SponsorId",
                        column: x => x.SponsorId,
                        principalTable: "Users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Tournaments",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Name = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Location = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    MaxPlayer = table.Column<int>(type: "int", nullable: false),
                    Descreption = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    IsMinRanking = table.Column<int>(type: "int", nullable: true),
                    IsMaxRanking = table.Column<int>(type: "int", nullable: true),
                    Banner = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Social = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    Note = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    TotalPrize = table.Column<decimal>(type: "decimal(18,2)", nullable: false),
                    StartDate = table.Column<DateTime>(type: "datetime2", nullable: false),
                    EndDate = table.Column<DateTime>(type: "datetime2", nullable: false),
                    CreateAt = table.Column<DateTime>(type: "datetime2", nullable: false),
                    Type = table.Column<int>(type: "int", nullable: false),
                    Status = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    IsAccept = table.Column<bool>(type: "bit", nullable: false),
                    IsFree = table.Column<bool>(type: "bit", nullable: false),
                    EntryFee = table.Column<decimal>(type: "decimal(18,2)", nullable: true),
                    OrganizerId = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Tournaments", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Tournaments_Users_OrganizerId",
                        column: x => x.OrganizerId,
                        principalTable: "Users",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateTable(
                name: "Venues",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Name = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Address = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Capacity = table.Column<int>(type: "int", nullable: false),
                    UrlImage = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    CreateBy = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Venues", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Venues_Users_CreateBy",
                        column: x => x.CreateBy,
                        principalTable: "Users",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateTable(
                name: "Payments",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    UserId = table.Column<int>(type: "int", nullable: false),
                    TournamentId = table.Column<int>(type: "int", nullable: false),
                    Amount = table.Column<decimal>(type: "decimal(18,2)", nullable: false),
                    Note = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    PaymentMethod = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    Status = table.Column<int>(type: "int", nullable: false),
                    Type = table.Column<int>(type: "int", nullable: false),
                    PaymentDate = table.Column<DateTime>(type: "datetime2", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Payments", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Payments_Tournaments_TournamentId",
                        column: x => x.TournamentId,
                        principalTable: "Tournaments",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK_Payments_Users_UserId",
                        column: x => x.UserId,
                        principalTable: "Users",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateTable(
                name: "Rankings",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    PlayerId = table.Column<int>(type: "int", nullable: false),
                    TournamentId = table.Column<int>(type: "int", nullable: false),
                    Points = table.Column<int>(type: "int", nullable: false),
                    Position = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Rankings", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Rankings_Player_PlayerId",
                        column: x => x.PlayerId,
                        principalTable: "Player",
                        principalColumn: "PlayerId");
                    table.ForeignKey(
                        name: "FK_Rankings_Tournaments_TournamentId",
                        column: x => x.TournamentId,
                        principalTable: "Tournaments",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "sponnerTouraments",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    TournamentId = table.Column<int>(type: "int", nullable: false),
                    SponsorId = table.Column<int>(type: "int", nullable: false),
                    SponsorAmount = table.Column<decimal>(type: "decimal(18,2)", nullable: true),
                    SponsorNote = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_sponnerTouraments", x => x.Id);
                    table.ForeignKey(
                        name: "FK_sponnerTouraments_Sponsors_SponsorId",
                        column: x => x.SponsorId,
                        principalTable: "Sponsors",
                        principalColumn: "SponsorId");
                    table.ForeignKey(
                        name: "FK_sponnerTouraments_Tournaments_TournamentId",
                        column: x => x.TournamentId,
                        principalTable: "Tournaments",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateTable(
                name: "TournamentReferees",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    TournamentId = table.Column<int>(type: "int", nullable: false),
                    RefereeId = table.Column<int>(type: "int", nullable: false),
                    AssignedDate = table.Column<DateTime>(type: "datetime2", nullable: false),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false),
                    IsDone = table.Column<bool>(type: "bit", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_TournamentReferees", x => x.Id);
                    table.ForeignKey(
                        name: "FK_TournamentReferees_Refree_RefereeId",
                        column: x => x.RefereeId,
                        principalTable: "Refree",
                        principalColumn: "RefreeId");
                    table.ForeignKey(
                        name: "FK_TournamentReferees_Tournaments_TournamentId",
                        column: x => x.TournamentId,
                        principalTable: "Tournaments",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateTable(
                name: "TournamentRegistrations",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    TournamentId = table.Column<int>(type: "int", nullable: false),
                    PlayerId = table.Column<int>(type: "int", nullable: false),
                    PartnerId = table.Column<int>(type: "int", nullable: true),
                    RegisteredAt = table.Column<DateTime>(type: "datetime2", nullable: false),
                    IsApproved = table.Column<int>(type: "int", nullable: false),
                    Reason = table.Column<string>(type: "nvarchar(max)", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_TournamentRegistrations", x => x.Id);
                    table.ForeignKey(
                        name: "FK_TournamentRegistrations_Player_PartnerId",
                        column: x => x.PartnerId,
                        principalTable: "Player",
                        principalColumn: "PlayerId");
                    table.ForeignKey(
                        name: "FK_TournamentRegistrations_Player_PlayerId",
                        column: x => x.PlayerId,
                        principalTable: "Player",
                        principalColumn: "PlayerId");
                    table.ForeignKey(
                        name: "FK_TournamentRegistrations_Tournaments_TournamentId",
                        column: x => x.TournamentId,
                        principalTable: "Tournaments",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Matches",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Title = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Description = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    MatchDate = table.Column<DateTime>(type: "datetime2", nullable: false),
                    CreateAt = table.Column<DateTime>(type: "datetime2", nullable: true),
                    VenueId = table.Column<int>(type: "int", nullable: true),
                    Status = table.Column<int>(type: "int", nullable: false),
                    MatchCategory = table.Column<int>(type: "int", nullable: false),
                    MatchFormat = table.Column<int>(type: "int", nullable: false),
                    WinScore = table.Column<int>(type: "int", nullable: false),
                    UrlVideoMatch = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    Team1Score = table.Column<int>(type: "int", nullable: true),
                    Team2Score = table.Column<int>(type: "int", nullable: true),
                    IsPublic = table.Column<bool>(type: "bit", nullable: false),
                    Log = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    RoomOwner = table.Column<int>(type: "int", nullable: false),
                    RefereeId = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Matches", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Matches_Users_RefereeId",
                        column: x => x.RefereeId,
                        principalTable: "Users",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK_Matches_Users_RoomOwner",
                        column: x => x.RoomOwner,
                        principalTable: "Users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_Matches_Venues_VenueId",
                        column: x => x.VenueId,
                        principalTable: "Venues",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateTable(
                name: "TournamentProgresses",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    TournamentRegistrationId = table.Column<int>(type: "int", nullable: false),
                    RoundNumber = table.Column<int>(type: "int", nullable: false),
                    IsEliminated = table.Column<bool>(type: "bit", nullable: false),
                    Wins = table.Column<int>(type: "int", nullable: false),
                    Losses = table.Column<int>(type: "int", nullable: false),
                    LastUpdated = table.Column<DateTime>(type: "datetime2", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_TournamentProgresses", x => x.Id);
                    table.ForeignKey(
                        name: "FK_TournamentProgresses_TournamentRegistrations_TournamentRegistrationId",
                        column: x => x.TournamentRegistrationId,
                        principalTable: "TournamentRegistrations",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateTable(
                name: "tournamentTeamRequests",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    RegistrationId = table.Column<int>(type: "int", nullable: false),
                    RequesterId = table.Column<int>(type: "int", nullable: false),
                    PartnerId = table.Column<int>(type: "int", nullable: false),
                    Status = table.Column<int>(type: "int", nullable: false),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_tournamentTeamRequests", x => x.Id);
                    table.ForeignKey(
                        name: "FK_tournamentTeamRequests_TournamentRegistrations_RegistrationId",
                        column: x => x.RegistrationId,
                        principalTable: "TournamentRegistrations",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "MatchesSendRequest",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    MatchingId = table.Column<int>(type: "int", nullable: false),
                    PlayerRequestId = table.Column<int>(type: "int", nullable: false),
                    PlayerRecieveId = table.Column<int>(type: "int", nullable: false),
                    status = table.Column<int>(type: "int", nullable: false),
                    CreateAt = table.Column<DateTime>(type: "datetime2", nullable: false),
                    LastUpdatedAt = table.Column<DateTime>(type: "datetime2", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_MatchesSendRequest", x => x.Id);
                    table.ForeignKey(
                        name: "FK_MatchesSendRequest_Matches_MatchingId",
                        column: x => x.MatchingId,
                        principalTable: "Matches",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_MatchesSendRequest_Player_PlayerRecieveId",
                        column: x => x.PlayerRecieveId,
                        principalTable: "Player",
                        principalColumn: "PlayerId");
                    table.ForeignKey(
                        name: "FK_MatchesSendRequest_Player_PlayerRequestId",
                        column: x => x.PlayerRequestId,
                        principalTable: "Player",
                        principalColumn: "PlayerId");
                });

            migrationBuilder.CreateTable(
                name: "MatchScore",
                columns: table => new
                {
                    MatchScoreId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    MatchId = table.Column<int>(type: "int", nullable: false),
                    Round = table.Column<int>(type: "int", nullable: true),
                    Note = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    CurrentHaft = table.Column<int>(type: "int", nullable: true),
                    Team1Score = table.Column<int>(type: "int", nullable: false),
                    Team2Score = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_MatchScore", x => x.MatchScoreId);
                    table.ForeignKey(
                        name: "FK_MatchScore_Matches_MatchId",
                        column: x => x.MatchId,
                        principalTable: "Matches",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateTable(
                name: "Teams",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Name = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    CaptainId = table.Column<int>(type: "int", nullable: true),
                    MatchingId = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Teams", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Teams_Matches_MatchingId",
                        column: x => x.MatchingId,
                        principalTable: "Matches",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_Teams_Player_CaptainId",
                        column: x => x.CaptainId,
                        principalTable: "Player",
                        principalColumn: "PlayerId");
                });

            migrationBuilder.CreateTable(
                name: "TouramentMatches",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    TournamentId = table.Column<int>(type: "int", nullable: false),
                    MatchesId = table.Column<int>(type: "int", nullable: false),
                    CreateAt = table.Column<DateTime>(type: "datetime2", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_TouramentMatches", x => x.Id);
                    table.ForeignKey(
                        name: "FK_TouramentMatches_Matches_MatchesId",
                        column: x => x.MatchesId,
                        principalTable: "Matches",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK_TouramentMatches_Tournaments_TournamentId",
                        column: x => x.TournamentId,
                        principalTable: "Tournaments",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateTable(
                name: "TeamMembers",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    TeamId = table.Column<int>(type: "int", nullable: false),
                    PlayerId = table.Column<int>(type: "int", nullable: false),
                    JoinedAt = table.Column<DateTime>(type: "datetime2", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_TeamMembers", x => x.Id);
                    table.ForeignKey(
                        name: "FK_TeamMembers_Player_PlayerId",
                        column: x => x.PlayerId,
                        principalTable: "Player",
                        principalColumn: "PlayerId");
                    table.ForeignKey(
                        name: "FK_TeamMembers_Teams_TeamId",
                        column: x => x.TeamId,
                        principalTable: "Teams",
                        principalColumn: "Id");
                });

            migrationBuilder.InsertData(
                table: "Roles",
                columns: new[] { "RoleId", "RoleName" },
                values: new object[,]
                {
                    { 1, "Player" },
                    { 2, "Admin" },
                    { 3, "Sponsor" },
                    { 4, "Referee" },
                    { 5, "User" },
                    { 6, "Staff" },
                    { 7, "=Admin Club" }
                });

            migrationBuilder.CreateIndex(
                name: "IX_Achievements_UserId",
                table: "Achievements",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "IX_Friends_User1Id",
                table: "Friends",
                column: "User1Id");

            migrationBuilder.CreateIndex(
                name: "IX_Friends_User2Id",
                table: "Friends",
                column: "User2Id");

            migrationBuilder.CreateIndex(
                name: "IX_Matches_RefereeId",
                table: "Matches",
                column: "RefereeId");

            migrationBuilder.CreateIndex(
                name: "IX_Matches_RoomOwner",
                table: "Matches",
                column: "RoomOwner");

            migrationBuilder.CreateIndex(
                name: "IX_Matches_VenueId",
                table: "Matches",
                column: "VenueId");

            migrationBuilder.CreateIndex(
                name: "IX_MatchesSendRequest_MatchingId",
                table: "MatchesSendRequest",
                column: "MatchingId");

            migrationBuilder.CreateIndex(
                name: "IX_MatchesSendRequest_PlayerRecieveId",
                table: "MatchesSendRequest",
                column: "PlayerRecieveId");

            migrationBuilder.CreateIndex(
                name: "IX_MatchesSendRequest_PlayerRequestId",
                table: "MatchesSendRequest",
                column: "PlayerRequestId");

            migrationBuilder.CreateIndex(
                name: "IX_MatchScore_MatchId",
                table: "MatchScore",
                column: "MatchId");

            migrationBuilder.CreateIndex(
                name: "IX_Notifications_UserId",
                table: "Notifications",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "IX_Payments_TournamentId",
                table: "Payments",
                column: "TournamentId");

            migrationBuilder.CreateIndex(
                name: "IX_Payments_UserId",
                table: "Payments",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "IX_Rankings_PlayerId",
                table: "Rankings",
                column: "PlayerId");

            migrationBuilder.CreateIndex(
                name: "IX_Rankings_TournamentId",
                table: "Rankings",
                column: "TournamentId");

            migrationBuilder.CreateIndex(
                name: "IX_Rules_BlogCategoryId",
                table: "Rules",
                column: "BlogCategoryId");

            migrationBuilder.CreateIndex(
                name: "IX_sponnerTouraments_SponsorId",
                table: "sponnerTouraments",
                column: "SponsorId");

            migrationBuilder.CreateIndex(
                name: "IX_sponnerTouraments_TournamentId",
                table: "sponnerTouraments",
                column: "TournamentId");

            migrationBuilder.CreateIndex(
                name: "IX_TeamMembers_PlayerId",
                table: "TeamMembers",
                column: "PlayerId");

            migrationBuilder.CreateIndex(
                name: "IX_TeamMembers_TeamId",
                table: "TeamMembers",
                column: "TeamId");

            migrationBuilder.CreateIndex(
                name: "IX_Teams_CaptainId",
                table: "Teams",
                column: "CaptainId");

            migrationBuilder.CreateIndex(
                name: "IX_Teams_MatchingId",
                table: "Teams",
                column: "MatchingId");

            migrationBuilder.CreateIndex(
                name: "IX_TouramentMatches_MatchesId",
                table: "TouramentMatches",
                column: "MatchesId");

            migrationBuilder.CreateIndex(
                name: "IX_TouramentMatches_TournamentId",
                table: "TouramentMatches",
                column: "TournamentId");

            migrationBuilder.CreateIndex(
                name: "IX_TournamentProgresses_TournamentRegistrationId",
                table: "TournamentProgresses",
                column: "TournamentRegistrationId");

            migrationBuilder.CreateIndex(
                name: "IX_TournamentReferees_RefereeId",
                table: "TournamentReferees",
                column: "RefereeId");

            migrationBuilder.CreateIndex(
                name: "IX_TournamentReferees_TournamentId",
                table: "TournamentReferees",
                column: "TournamentId");

            migrationBuilder.CreateIndex(
                name: "IX_TournamentRegistrations_PartnerId",
                table: "TournamentRegistrations",
                column: "PartnerId");

            migrationBuilder.CreateIndex(
                name: "IX_TournamentRegistrations_PlayerId",
                table: "TournamentRegistrations",
                column: "PlayerId");

            migrationBuilder.CreateIndex(
                name: "IX_TournamentRegistrations_TournamentId",
                table: "TournamentRegistrations",
                column: "TournamentId");

            migrationBuilder.CreateIndex(
                name: "IX_Tournaments_OrganizerId",
                table: "Tournaments",
                column: "OrganizerId");

            migrationBuilder.CreateIndex(
                name: "IX_tournamentTeamRequests_RegistrationId",
                table: "tournamentTeamRequests",
                column: "RegistrationId");

            migrationBuilder.CreateIndex(
                name: "IX_Users_RoleId",
                table: "Users",
                column: "RoleId");

            migrationBuilder.CreateIndex(
                name: "IX_Venues_CreateBy",
                table: "Venues",
                column: "CreateBy");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "Achievements");

            migrationBuilder.DropTable(
                name: "Friends");

            migrationBuilder.DropTable(
                name: "MatchesSendRequest");

            migrationBuilder.DropTable(
                name: "MatchScore");

            migrationBuilder.DropTable(
                name: "Notifications");

            migrationBuilder.DropTable(
                name: "Payments");

            migrationBuilder.DropTable(
                name: "Rankings");

            migrationBuilder.DropTable(
                name: "Rules");

            migrationBuilder.DropTable(
                name: "RulesScores");

            migrationBuilder.DropTable(
                name: "sponnerTouraments");

            migrationBuilder.DropTable(
                name: "TeamMembers");

            migrationBuilder.DropTable(
                name: "TouramentMatches");

            migrationBuilder.DropTable(
                name: "TournamentProgresses");

            migrationBuilder.DropTable(
                name: "TournamentReferees");

            migrationBuilder.DropTable(
                name: "tournamentTeamRequests");

            migrationBuilder.DropTable(
                name: "transactionPayments");

            migrationBuilder.DropTable(
                name: "BlogCategories");

            migrationBuilder.DropTable(
                name: "Sponsors");

            migrationBuilder.DropTable(
                name: "Teams");

            migrationBuilder.DropTable(
                name: "Refree");

            migrationBuilder.DropTable(
                name: "TournamentRegistrations");

            migrationBuilder.DropTable(
                name: "Matches");

            migrationBuilder.DropTable(
                name: "Player");

            migrationBuilder.DropTable(
                name: "Tournaments");

            migrationBuilder.DropTable(
                name: "Venues");

            migrationBuilder.DropTable(
                name: "Users");

            migrationBuilder.DropTable(
                name: "Roles");
        }
    }
}
