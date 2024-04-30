using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace DineEaseApp.Migrations
{
    public partial class SixthUpdate : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_PhotosRestaurants_Photos_PhotoId",
                table: "PhotosRestaurants");

            migrationBuilder.DropTable(
                name: "Photos");

            migrationBuilder.RenameColumn(
                name: "PhotoId",
                table: "PhotosRestaurants",
                newName: "Id");

            migrationBuilder.AddColumn<string>(
                name: "Image",
                table: "PhotosRestaurants",
                type: "nvarchar(max)",
                nullable: true);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "Image",
                table: "PhotosRestaurants");

            migrationBuilder.RenameColumn(
                name: "Id",
                table: "PhotosRestaurants",
                newName: "PhotoId");

            migrationBuilder.CreateTable(
                name: "Photos",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Photograph = table.Column<byte[]>(type: "varbinary(max)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Photos", x => x.Id);
                });

            migrationBuilder.AddForeignKey(
                name: "FK_PhotosRestaurants_Photos_PhotoId",
                table: "PhotosRestaurants",
                column: "PhotoId",
                principalTable: "Photos",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }
    }
}
