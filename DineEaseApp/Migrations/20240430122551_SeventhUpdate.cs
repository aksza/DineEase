using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace DineEaseApp.Migrations
{
    public partial class SeventhUpdate : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {

            migrationBuilder.DropPrimaryKey(
                name: "PK_PhotosRestaurants",
                table: "PhotosRestaurants");

            migrationBuilder.DropColumn(
                name: "Id",
                table: "PhotosRestaurants");

            migrationBuilder.AddColumn<int>(
                name: "Id",
                table: "PhotosRestaurants",
                type: "int",
                nullable: false)
                .Annotation("SqlServer:Identity", "1, 1");

            migrationBuilder.AddPrimaryKey(
                name: "PK_PhotosRestaurants",
                table: "PhotosRestaurants",
                column: "Id");
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropPrimaryKey(
                name: "PK_PhotosRestaurants",
                table: "PhotosRestaurants");

            migrationBuilder.DropColumn(
                name: "Id",
                table: "PhotosRestaurants");

            migrationBuilder.AddColumn<int>(
                name: "Id",
                table: "PhotosRestaurants",
                type: "int",
                nullable: false)
                .Annotation("SqlServer:Identity", "1, 1");

            migrationBuilder.AddPrimaryKey(
                name: "PK_PhotosRestaurants",
                table: "PhotosRestaurants",
                columns: new[] { "Id", "RestaurantId" });
        }
    }
}
