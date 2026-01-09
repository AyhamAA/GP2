using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class Addcartitemincontext : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "CartItems",
                columns: table => new
                {
                    CartItemId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    ItemName = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Quantity = table.Column<int>(type: "int", nullable: false),
                    ItemType = table.Column<int>(type: "int", nullable: false),
                    UserId = table.Column<int>(type: "int", nullable: false),
                    DonationEquipmentId = table.Column<int>(type: "int", nullable: false),
                    DonationMedicineId = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_CartItems", x => x.CartItemId);
                    table.ForeignKey(
                        name: "FK_CartItems_DonationEquipments_DonationEquipmentId",
                        column: x => x.DonationEquipmentId,
                        principalTable: "DonationEquipments",
                        principalColumn: "DonationEquipmentId",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_CartItems_DonationMedicines_DonationMedicineId",
                        column: x => x.DonationMedicineId,
                        principalTable: "DonationMedicines",
                        principalColumn: "DonationMedicineId",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_CartItems_Users_UserId",
                        column: x => x.UserId,
                        principalTable: "Users",
                        principalColumn: "UserId",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_CartItems_DonationEquipmentId",
                table: "CartItems",
                column: "DonationEquipmentId");

            migrationBuilder.CreateIndex(
                name: "IX_CartItems_DonationMedicineId",
                table: "CartItems",
                column: "DonationMedicineId");

            migrationBuilder.CreateIndex(
                name: "IX_CartItems_UserId",
                table: "CartItems",
                column: "UserId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "CartItems");
        }
    }
}
