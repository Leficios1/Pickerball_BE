using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Database.Migrations
{
    /// <inheritdoc />
    public partial class UpdateDbTouramentTeamRequest : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateIndex(
                name: "IX_tournamentTeamRequests_PartnerId",
                table: "tournamentTeamRequests",
                column: "PartnerId");

            migrationBuilder.CreateIndex(
                name: "IX_tournamentTeamRequests_RequesterId",
                table: "tournamentTeamRequests",
                column: "RequesterId");

            migrationBuilder.AddForeignKey(
                name: "FK_tournamentTeamRequests_Player_PartnerId",
                table: "tournamentTeamRequests",
                column: "PartnerId",
                principalTable: "Player",
                principalColumn: "PlayerId",
                onDelete: ReferentialAction.Restrict);

            migrationBuilder.AddForeignKey(
                name: "FK_tournamentTeamRequests_Player_RequesterId",
                table: "tournamentTeamRequests",
                column: "RequesterId",
                principalTable: "Player",
                principalColumn: "PlayerId",
                onDelete: ReferentialAction.Restrict);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_tournamentTeamRequests_Player_PartnerId",
                table: "tournamentTeamRequests");

            migrationBuilder.DropForeignKey(
                name: "FK_tournamentTeamRequests_Player_RequesterId",
                table: "tournamentTeamRequests");

            migrationBuilder.DropIndex(
                name: "IX_tournamentTeamRequests_PartnerId",
                table: "tournamentTeamRequests");

            migrationBuilder.DropIndex(
                name: "IX_tournamentTeamRequests_RequesterId",
                table: "tournamentTeamRequests");
        }
    }
}
