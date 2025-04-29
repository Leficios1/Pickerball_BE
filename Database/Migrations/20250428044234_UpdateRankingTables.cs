using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace Database.Migrations
{
    /// <inheritdoc />
    public partial class UpdateRankingTables : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<int>(
                name: "PercentOfPrize",
                table: "Rankings",
                type: "int",
                nullable: true);

            migrationBuilder.AddColumn<int>(
                name: "Prize",
                table: "Rankings",
                type: "int",
                nullable: true);

            migrationBuilder.CreateTable(
                name: "RuleOfAwards",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Position = table.Column<int>(type: "int", nullable: false),
                    PercentOfPrize = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_RuleOfAwards", x => x.Id);
                });

            migrationBuilder.InsertData(
                table: "RuleOfAwards",
                columns: new[] { "Id", "PercentOfPrize", "Position" },
                values: new object[,]
                {
                    { 1, 40, 1 },
                    { 2, 30, 2 },
                    { 3, 15, 3 },
                    { 4, 15, 4 }
                });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "RuleOfAwards");

            migrationBuilder.DropColumn(
                name: "PercentOfPrize",
                table: "Rankings");

            migrationBuilder.DropColumn(
                name: "Prize",
                table: "Rankings");
        }
    }
}
