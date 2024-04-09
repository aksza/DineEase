using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace DineEaseApp.Migrations
{
    public partial class UpdatedDatabase : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Reservations_Orders_OrderId",
                table: "Reservations");

            migrationBuilder.DropIndex(
                name: "IX_Reservations_OrderId",
                table: "Reservations");

            migrationBuilder.DropColumn(
                name: "OrderId",
                table: "Reservations");

            migrationBuilder.AlterColumn<double>(
                name: "Rating",
                table: "Restaurants",
                type: "float",
                nullable: false,
                oldClrType: typeof(float),
                oldType: "real");

            migrationBuilder.AddColumn<int>(
                name: "ReservationId",
                table: "Orders",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.CreateIndex(
                name: "IX_Orders_ReservationId",
                table: "Orders",
                column: "ReservationId");

            migrationBuilder.AddForeignKey(
                name: "FK_Orders_Reservations_ReservationId",
                table: "Orders",
                column: "ReservationId",
                principalTable: "Reservations",
                principalColumn: "Id"
                );
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Orders_Reservations_ReservationId",
                table: "Orders");

            migrationBuilder.DropIndex(
                name: "IX_Orders_ReservationId",
                table: "Orders");

            migrationBuilder.DropColumn(
                name: "ReservationId",
                table: "Orders");

            migrationBuilder.AlterColumn<float>(
                name: "Rating",
                table: "Restaurants",
                type: "real",
                nullable: false,
                oldClrType: typeof(double),
                oldType: "float");

            migrationBuilder.AddColumn<int>(
                name: "OrderId",
                table: "Reservations",
                type: "int",
                nullable: true);

            migrationBuilder.CreateIndex(
                name: "IX_Reservations_OrderId",
                table: "Reservations",
                column: "OrderId");

            migrationBuilder.AddForeignKey(
                name: "FK_Reservations_Orders_OrderId",
                table: "Reservations",
                column: "OrderId",
                principalTable: "Orders",
                principalColumn: "Id");
        }
    }
}
