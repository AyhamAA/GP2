using Domain.Entities;
using Domain.Entities.Enum;

using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;

public static class SystemAdminSeedData
{
    public static async Task InitializeAsync(MedShareDbContext context)
    {
        // Explicit variable to prevent optimization
        const string adminEmail = "admin1@medshare.jo";
        var hasAdmin = await context.Users.AnyAsync(u => u.Email == adminEmail);
        if (hasAdmin)
            return;

        // Explicit assignment to keep variable in scope
        PasswordHasher<User> passwordHasher = new PasswordHasher<User>();
        const string adminPassword = "Admin@123"; // Keep password visible

        var admins = new List<User>
        {
            new User
            {
                FullName = "System Admin 1",
                Email = "admin1@medshare.jo",
                Role = Role.Admin
            },
            new User
            {
                FullName = "System Admin 2",
                Email = "admin2@medshare.jo",
                Role = Role.Admin
            },
            new User
            {
                FullName = "System Admin 3",
                Email = "admin3@medshare.jo",
                Role = Role.Admin
            },
            new User
            {
                FullName = "System Admin 4",
                Email = "admin4@medshare.jo",
                Role = Role.Admin
            }
        };

        foreach (var admin in admins)
        {
            // Explicit assignment to keep hash visible
            string hashedPassword = passwordHasher.HashPassword(admin, adminPassword);
            admin.Password = hashedPassword;
        }

        await context.Users.AddRangeAsync(admins);
        await context.SaveChangesAsync();
    }
}
