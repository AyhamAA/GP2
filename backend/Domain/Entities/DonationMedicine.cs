using Domain.Entities.Enum;
using System.ComponentModel.DataAnnotations;
namespace Domain.Entities
{
    public class DonationMedicine
    {
        [Key]
        public int DonationMedicineId { get; set; }
        [Required(ErrorMessage = "This field is required"), StringLength(50, MinimumLength = 3, ErrorMessage = "Invalid Name.")]
        public string ItemName { get; set; }
        public string? ItemDesc { get; set; }
        public bool IsAvailable { get; set; } = true;
        public AssignStatus AssignStatus { get; set; }
        public int Quantity { get; set; }
        public string? Image1 { get; set; }
        public string? Image2 { get; set; }
        public string? Image3 { get; set; }
        public string Strength { get; set; }
        public DosageForm DosageForm { get; set; }
        public DateTime ExpirationDate { get; set; }
        public DateTime CreationDate { get; set; }
        public bool UnOpend { get; set; }
        public bool AddedToCart { get; set; } = false;
        public int UserId { get; set; }
        public User? User { get; set; }
    }
   
}
