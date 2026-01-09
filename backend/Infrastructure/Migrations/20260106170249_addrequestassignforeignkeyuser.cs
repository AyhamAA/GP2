using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class addrequestassignforeignkeyuser : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<int>(
                name: "DonationEquipmentId",
                table: "RequestAssigns",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<int>(
                name: "DonationMedicineId",
                table: "RequestAssigns",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.CreateIndex(
                name: "IX_RequestAssigns_DonationEquipmentId",
                table: "RequestAssigns",
                column: "DonationEquipmentId");

            migrationBuilder.CreateIndex(
                name: "IX_RequestAssigns_DonationMedicineId",
                table: "RequestAssigns",
                column: "DonationMedicineId");

            migrationBuilder.CreateIndex(
                name: "IX_RequestAssigns_UserId",
                table: "RequestAssigns",
                column: "UserId");

            migrationBuilder.AddForeignKey(
                name: "FK_RequestAssigns_DonationEquipments_DonationEquipmentId",
                table: "RequestAssigns",
                column: "DonationEquipmentId",
                principalTable: "DonationEquipments",
                principalColumn: "DonationEquipmentId",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_RequestAssigns_DonationMedicines_DonationMedicineId",
                table: "RequestAssigns",
                column: "DonationMedicineId",
                principalTable: "DonationMedicines",
                principalColumn: "DonationMedicineId",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_RequestAssigns_Users_UserId",
                table: "RequestAssigns",
                column: "UserId",
                principalTable: "Users",
                principalColumn: "UserId",
                onDelete: ReferentialAction.Cascade);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_RequestAssigns_DonationEquipments_DonationEquipmentId",
                table: "RequestAssigns");

            migrationBuilder.DropForeignKey(
                name: "FK_RequestAssigns_DonationMedicines_DonationMedicineId",
                table: "RequestAssigns");

            migrationBuilder.DropForeignKey(
                name: "FK_RequestAssigns_Users_UserId",
                table: "RequestAssigns");

            migrationBuilder.DropIndex(
                name: "IX_RequestAssigns_DonationEquipmentId",
                table: "RequestAssigns");

            migrationBuilder.DropIndex(
                name: "IX_RequestAssigns_DonationMedicineId",
                table: "RequestAssigns");

            migrationBuilder.DropIndex(
                name: "IX_RequestAssigns_UserId",
                table: "RequestAssigns");

            migrationBuilder.DropColumn(
                name: "DonationEquipmentId",
                table: "RequestAssigns");

            migrationBuilder.DropColumn(
                name: "DonationMedicineId",
                table: "RequestAssigns");
        }
    }
}
