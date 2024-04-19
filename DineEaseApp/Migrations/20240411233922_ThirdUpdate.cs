using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace DineEaseApp.Migrations
{
    public partial class ThirdUpdate : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Meetings_Events_EventId",
                table: "Meetings");

            migrationBuilder.DropForeignKey(
                name: "FK_Meetings_EventTypes_EventTypeId",
                table: "Meetings");

            migrationBuilder.DropIndex(
                name: "IX_Meetings_EventTypeId",
                table: "Meetings");

            migrationBuilder.DropColumn(
                name: "EventTypeId",
                table: "Meetings");

            migrationBuilder.AddColumn<double>(
                name: "Price",
                table: "Menus",
                type: "float",
                nullable: false,
                defaultValue: 0.0);

            migrationBuilder.AddForeignKey(
                name: "FK_Meetings_EventTypes_EventId",
                table: "Meetings",
                column: "EventId",
                principalTable: "EventTypes",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Meetings_EventTypes_EventId",
                table: "Meetings");

            migrationBuilder.DropColumn(
                name: "Price",
                table: "Menus");

            migrationBuilder.AddColumn<int>(
                name: "EventTypeId",
                table: "Meetings",
                type: "int",
                nullable: true);

            migrationBuilder.CreateIndex(
                name: "IX_Meetings_EventTypeId",
                table: "Meetings",
                column: "EventTypeId");

            migrationBuilder.AddForeignKey(
                name: "FK_Meetings_Events_EventId",
                table: "Meetings",
                column: "EventId",
                principalTable: "Events",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_Meetings_EventTypes_EventTypeId",
                table: "Meetings",
                column: "EventTypeId",
                principalTable: "EventTypes",
                principalColumn: "Id");
        }
    }
}
