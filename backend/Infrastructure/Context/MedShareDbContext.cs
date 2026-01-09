using Domain.Entities;
using Microsoft.EntityFrameworkCore;

public class MedShareDbContext : DbContext
{
    public MedShareDbContext(DbContextOptions<MedShareDbContext> options)
        : base(options)
    {
    }

    public DbSet<User> Users { get; set; }
    public DbSet<DonationEquipment> DonationEquipments { get; set; }
    public DbSet<DonationMedicine> DonationMedicines { get; set; }
    public DbSet<RequestMedicine> RequestMedicines { get; set; }
    public DbSet<RequestEquipment> RequestEquipments { get; set; }
    public DbSet<RefreshToken> RefreshTokens { get; set; }
    public DbSet<RequestTask> RequestTasks { get; set; }
    public DbSet<RequestAssign> RequestAssigns { get; set; }
    public DbSet<CartItem> CartItems { get; set; }
    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);

        modelBuilder.Entity<DonationEquipment>()
            .HasOne(d => d.User)
            .WithMany(u => u.MyDonationEquipments)
            .HasForeignKey(d => d.UserId)
            .OnDelete(DeleteBehavior.Restrict);

        modelBuilder.Entity<DonationMedicine>()
            .HasOne(d => d.User)
            .WithMany(u => u.MyDonationMedicines)
            .HasForeignKey(d => d.UserId)
            .OnDelete(DeleteBehavior.Restrict);

        modelBuilder.Entity<RequestMedicine>()
            .HasOne(r => r.User)
            .WithMany(u => u.MyRequestMedicines)
            .HasForeignKey(r => r.UserId)
            .OnDelete(DeleteBehavior.NoAction);

        modelBuilder.Entity<RequestEquipment>()
            .HasOne(r => r.User)
            .WithMany(u => u.MyRequestEquipments)
            .HasForeignKey(r => r.UserId)
            .OnDelete(DeleteBehavior.NoAction);

    }

}
