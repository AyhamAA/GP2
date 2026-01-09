using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class editAllTables : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "Users",
                columns: table => new
                {
                    UserId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    FullName = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    Email = table.Column<string>(type: "nvarchar(70)", maxLength: 70, nullable: false),
                    Password = table.Column<string>(type: "nvarchar(500)", maxLength: 500, nullable: true),
                    PhoneNumber = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    ImageProfile = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    Role = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Users", x => x.UserId);
                });

            migrationBuilder.CreateTable(
                name: "DonationEquipments",
                columns: table => new
                {
                    DonationEquipmentId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    ItemName = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    ItemDesc = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    IsOrderd = table.Column<bool>(type: "bit", nullable: false),
                    IsAvailable = table.Column<bool>(type: "bit", nullable: false),
                    AssignStatus = table.Column<int>(type: "int", nullable: false),
                    Quantity = table.Column<int>(type: "int", nullable: false),
                    IsWokringFully = table.Column<bool>(type: "bit", nullable: false),
                    Image1 = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    Image2 = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    Image3 = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    UserAssignedTo = table.Column<int>(type: "int", nullable: true),
                    Condition = table.Column<int>(type: "int", nullable: false),
                    Accessories = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    CreationDate = table.Column<DateTime>(type: "datetime2", nullable: false),
                    UserId = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_DonationEquipments", x => x.DonationEquipmentId);
                    table.ForeignKey(
                        name: "FK_DonationEquipments_Users_UserId",
                        column: x => x.UserId,
                        principalTable: "Users",
                        principalColumn: "UserId",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "DonationMedicines",
                columns: table => new
                {
                    DonationMedicineId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    ItemName = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    ItemDesc = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    IsOrderd = table.Column<bool>(type: "bit", nullable: false),
                    IsAvailable = table.Column<bool>(type: "bit", nullable: false),
                    AssignStatus = table.Column<int>(type: "int", nullable: false),
                    Quantity = table.Column<int>(type: "int", nullable: false),
                    Image1 = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    Image2 = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    Image3 = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    UserAssignedTo = table.Column<int>(type: "int", nullable: true),
                    Strength = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    DosageForm = table.Column<int>(type: "int", nullable: false),
                    ExpirationDate = table.Column<DateTime>(type: "datetime2", nullable: false),
                    CreationDate = table.Column<DateTime>(type: "datetime2", nullable: false),
                    UnOpend = table.Column<bool>(type: "bit", nullable: false),
                    UserId = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_DonationMedicines", x => x.DonationMedicineId);
                    table.ForeignKey(
                        name: "FK_DonationMedicines_Users_UserId",
                        column: x => x.UserId,
                        principalTable: "Users",
                        principalColumn: "UserId",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "RefreshTokens",
                columns: table => new
                {
                    RefreshTokenId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Token = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    Expires = table.Column<DateTime>(type: "datetime2", nullable: false),
                    UserId = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_RefreshTokens", x => x.RefreshTokenId);
                    table.ForeignKey(
                        name: "FK_RefreshTokens_Users_UserId",
                        column: x => x.UserId,
                        principalTable: "Users",
                        principalColumn: "UserId",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "RequestEquipments",
                columns: table => new
                {
                    RequestEquipmentId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    ItemName = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    ItemDesc = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    IsAvailable = table.Column<bool>(type: "bit", nullable: false),
                    Image1 = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    Image2 = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Image3 = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    IsWokringFully = table.Column<bool>(type: "bit", nullable: false),
                    Quantity = table.Column<int>(type: "int", nullable: false),
                    Condition = table.Column<int>(type: "int", nullable: false),
                    Accessories = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    CreationDate = table.Column<DateTime>(type: "datetime2", nullable: false),
                    UserId = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_RequestEquipments", x => x.RequestEquipmentId);
                    table.ForeignKey(
                        name: "FK_RequestEquipments_Users_UserId",
                        column: x => x.UserId,
                        principalTable: "Users",
                        principalColumn: "UserId");
                });

            migrationBuilder.CreateTable(
                name: "RequestMedicines",
                columns: table => new
                {
                    RequestMedicineId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    ItemName = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    ItemDesc = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    IsAvailable = table.Column<bool>(type: "bit", nullable: false),
                    Image1 = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    Image2 = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Image3 = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Quantity = table.Column<int>(type: "int", nullable: false),
                    Strength = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    DosageForm = table.Column<int>(type: "int", nullable: false),
                    ExpirationDate = table.Column<DateTime>(type: "datetime2", nullable: false),
                    UnOpend = table.Column<bool>(type: "bit", nullable: true),
                    Status = table.Column<int>(type: "int", nullable: true),
                    CreationDate = table.Column<DateTime>(type: "datetime2", nullable: false),
                    UserId = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_RequestMedicines", x => x.RequestMedicineId);
                    table.ForeignKey(
                        name: "FK_RequestMedicines_Users_UserId",
                        column: x => x.UserId,
                        principalTable: "Users",
                        principalColumn: "UserId");
                });

            migrationBuilder.CreateTable(
                name: "RequestTasks",
                columns: table => new
                {
                    TaskId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Time = table.Column<TimeOnly>(type: "time", nullable: false),
                    Title = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    AdminId = table.Column<int>(type: "int", nullable: false),
                    UserId = table.Column<int>(type: "int", nullable: true),
                    AssignedDate = table.Column<DateTime>(type: "datetime2", nullable: false),
                    DueDate = table.Column<DateTime>(type: "datetime2", nullable: false),
                    Status = table.Column<int>(type: "int", nullable: false),
                    Notes = table.Column<string>(type: "nvarchar(max)", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_RequestTasks", x => x.TaskId);
                    table.ForeignKey(
                        name: "FK_RequestTasks_Users_UserId",
                        column: x => x.UserId,
                        principalTable: "Users",
                        principalColumn: "UserId");
                });

            migrationBuilder.CreateIndex(
                name: "IX_DonationEquipments_UserId",
                table: "DonationEquipments",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "IX_DonationMedicines_UserId",
                table: "DonationMedicines",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "IX_RefreshTokens_UserId",
                table: "RefreshTokens",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "IX_RequestEquipments_UserId",
                table: "RequestEquipments",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "IX_RequestMedicines_UserId",
                table: "RequestMedicines",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "IX_RequestTasks_UserId",
                table: "RequestTasks",
                column: "UserId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "DonationEquipments");

            migrationBuilder.DropTable(
                name: "DonationMedicines");

            migrationBuilder.DropTable(
                name: "RefreshTokens");

            migrationBuilder.DropTable(
                name: "RequestEquipments");

            migrationBuilder.DropTable(
                name: "RequestMedicines");

            migrationBuilder.DropTable(
                name: "RequestTasks");

            migrationBuilder.DropTable(
                name: "Users");
        }
    }
}
