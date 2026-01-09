using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class forCartM : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "IsOrderd",
                table: "DonationMedicines");

            migrationBuilder.DropColumn(
                name: "IsOrderd",
                table: "DonationEquipments");

            migrationBuilder.CreateTable(
                name: "RequestAssigns",
                columns: table => new
                {
                    RequestAssignId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    DonationId = table.Column<int>(type: "int", nullable: false),
                    Quantity = table.Column<int>(type: "int", nullable: false),
                    UserId = table.Column<int>(type: "int", nullable: false),
                    Status = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_RequestAssigns", x => x.RequestAssignId);
                });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "RequestAssigns");

            migrationBuilder.AddColumn<bool>(
                name: "IsOrderd",
                table: "DonationMedicines",
                type: "bit",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<bool>(
                name: "IsOrderd",
                table: "DonationEquipments",
                type: "bit",
                nullable: false,
                defaultValue: false);
        }
    }
}
