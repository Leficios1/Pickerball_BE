using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Database.Migrations
{
    /// <inheritdoc />
    public partial class UpdateDBVn2 : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_TeamMembers_TournamentRegistrations_PlayerId",
                table: "TeamMembers");

            migrationBuilder.AddForeignKey(
                name: "FK_TeamMembers_Player_PlayerId",
                table: "TeamMembers",
                column: "PlayerId",
                principalTable: "Player",
                principalColumn: "PlayerId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_TeamMembers_Player_PlayerId",
                table: "TeamMembers");

            migrationBuilder.AddForeignKey(
                name: "FK_TeamMembers_TournamentRegistrations_PlayerId",
                table: "TeamMembers",
                column: "PlayerId",
                principalTable: "TournamentRegistrations",
                principalColumn: "Id");
        }
    }
}
