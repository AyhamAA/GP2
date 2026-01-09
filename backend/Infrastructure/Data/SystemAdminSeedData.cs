using Domain.Entities;
using Domain.Entities.Enum;

using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Hosting;

public static class SystemAdminSeedData
{
    public static async Task InitializeAsync(MedShareDbContext context, IConfiguration config, IHostEnvironment env)
    {
        // Seed admins only if no admins exist.
        var hasAdmin = await context.Users.AnyAsync(u => u.Role == Role.Admin);
        if (hasAdmin)
            return;

        var password = Environment.GetEnvironmentVariable("MEDSHARE_SEED_ADMIN_PASSWORD")
                       ?? config["SeedAdmin:Password"];

        if (string.IsNullOrWhiteSpace(password))
        {
            if (env.IsDevelopment())
            {
                // Dev-only convenience default. Do NOT use in production.
                password = "Admin@123";
            }
            else
            {
                throw new InvalidOperationException("Seed admin password is not configured. Set SeedAdmin:Password or env var MEDSHARE_SEED_ADMIN_PASSWORD.");
            }
        }

        var emailsCsv = Environment.GetEnvironmentVariable("MEDSHARE_SEED_ADMIN_EMAILS");
        var emails = !string.IsNullOrWhiteSpace(emailsCsv)
            ? emailsCsv.Split(',', StringSplitOptions.RemoveEmptyEntries | StringSplitOptions.TrimEntries)
            : config.GetSection("SeedAdmin:Emails").Get<string[]>();

        if (emails == null || emails.Length == 0)
        {
            if (env.IsDevelopment())
            {
                emails = new[]
                {
                    "admin1@medshare.jo",
                    "admin2@medshare.jo",
                    "admin3@medshare.jo",
                    "admin4@medshare.jo",
                };
            }
            else
            {
                throw new InvalidOperationException("Seed admin emails are not configured. Set SeedAdmin:Emails or env var MEDSHARE_SEED_ADMIN_EMAILS.");
            }
        }

        // Explicit assignment to keep variable in scope
        PasswordHasher<User> passwordHasher = new PasswordHasher<User>();

        var admins = new List<User>
        {

        };

        for (var i = 0; i < emails.Length; i++)
        {
            admins.Add(new User
            {
                FullName = $"System Admin {i + 1}",
                Email = emails[i],
                Role = Role.Admin
            });
        }

        foreach (var admin in admins)
        {
            // Explicit assignment to keep hash visible
            string hashedPassword = passwordHasher.HashPassword(admin, password);
            admin.Password = hashedPassword;
        }

        await context.Users.AddRangeAsync(admins);
        await context.SaveChangesAsync();
    }
}
