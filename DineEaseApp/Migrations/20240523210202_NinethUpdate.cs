using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace DineEaseApp.Migrations
{
    public partial class NinethUpdate : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<bool>(
                name: "Accepted",
                table: "Meetings",
                type: "bit",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "RestaurantResponse",
                table: "Meetings",
                type: "nvarchar(max)",
                nullable: true);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "Accepted",
                table: "Meetings");

            migrationBuilder.DropColumn(
                name: "RestaurantResponse",
                table: "Meetings");
        }
    }
}
