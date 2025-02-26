using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Database.Migrations
{
    /// <inheritdoc />
    public partial class UpdateDBVN6 : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Rules_RuleCategories_RuleCategoryId",
                table: "Rules");

            migrationBuilder.DropForeignKey(
                name: "FK_Teams_Matches_MatchingId",
                table: "Teams");

            migrationBuilder.DropForeignKey(
                name: "FK_Users_Roles_RoleId",
                table: "Users");

            migrationBuilder.DropPrimaryKey(
                name: "PK_RuleCategories",
                table: "RuleCategories");

            migrationBuilder.RenameTable(
                name: "RuleCategories",
                newName: "BlogCategories");

            migrationBuilder.RenameColumn(
                name: "RuleCategoryId",
                table: "Rules",
                newName: "BlogCategoryId");

            migrationBuilder.RenameIndex(
                name: "IX_Rules_RuleCategoryId",
                table: "Rules",
                newName: "IX_Rules_BlogCategoryId");

            migrationBuilder.AlterColumn<int>(
                name: "RoleId",
                table: "Users",
                type: "int",
                nullable: true,
                oldClrType: typeof(int),
                oldType: "int");

            migrationBuilder.AlterColumn<int>(
                name: "MatchingId",
                table: "Teams",
                type: "int",
                nullable: true,
                oldClrType: typeof(int),
                oldType: "int");

            migrationBuilder.AddPrimaryKey(
                name: "PK_BlogCategories",
                table: "BlogCategories",
                column: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_Rules_BlogCategories_BlogCategoryId",
                table: "Rules",
                column: "BlogCategoryId",
                principalTable: "BlogCategories",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_Teams_Matches_MatchingId",
                table: "Teams",
                column: "MatchingId",
                principalTable: "Matches",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_Users_Roles_RoleId",
                table: "Users",
                column: "RoleId",
                principalTable: "Roles",
                principalColumn: "RoleId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Rules_BlogCategories_BlogCategoryId",
                table: "Rules");

            migrationBuilder.DropForeignKey(
                name: "FK_Teams_Matches_MatchingId",
                table: "Teams");

            migrationBuilder.DropForeignKey(
                name: "FK_Users_Roles_RoleId",
                table: "Users");

            migrationBuilder.DropPrimaryKey(
                name: "PK_BlogCategories",
                table: "BlogCategories");

            migrationBuilder.RenameTable(
                name: "BlogCategories",
                newName: "RuleCategories");

            migrationBuilder.RenameColumn(
                name: "BlogCategoryId",
                table: "Rules",
                newName: "RuleCategoryId");

            migrationBuilder.RenameIndex(
                name: "IX_Rules_BlogCategoryId",
                table: "Rules",
                newName: "IX_Rules_RuleCategoryId");

            migrationBuilder.AlterColumn<int>(
                name: "RoleId",
                table: "Users",
                type: "int",
                nullable: false,
                defaultValue: 0,
                oldClrType: typeof(int),
                oldType: "int",
                oldNullable: true);

            migrationBuilder.AlterColumn<int>(
                name: "MatchingId",
                table: "Teams",
                type: "int",
                nullable: false,
                defaultValue: 0,
                oldClrType: typeof(int),
                oldType: "int",
                oldNullable: true);

            migrationBuilder.AddPrimaryKey(
                name: "PK_RuleCategories",
                table: "RuleCategories",
                column: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_Rules_RuleCategories_RuleCategoryId",
                table: "Rules",
                column: "RuleCategoryId",
                principalTable: "RuleCategories",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_Teams_Matches_MatchingId",
                table: "Teams",
                column: "MatchingId",
                principalTable: "Matches",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_Users_Roles_RoleId",
                table: "Users",
                column: "RoleId",
                principalTable: "Roles",
                principalColumn: "RoleId",
                onDelete: ReferentialAction.Cascade);
        }
    }
}
