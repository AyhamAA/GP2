using Domain.Entities.Enum;
using System.ComponentModel.DataAnnotations;

namespace Domain.Entities
{
    public class RequestMedicine
    {
        [Key]
        public int RequestMedicineId { get; set; }
        public string ItemName { get; set; }
        public string? ItemDesc { get; set; }
        public bool IsAvailable { get; set; }
        public string? Image1 { get; set; }
        public string Image2 { get; set; }
        public string Image3 { get; set; }
        public int Quantity { get; set; }
        public string Strength { get; set; }
        public DosageForm DosageForm { get; set; }
        public DateTime ExpirationDate { get; set; }
        public bool? UnOpend { get; set; }
        public StatusDonation? Status { get; set; } = StatusDonation.Pending;
        public DateTime CreationDate { get; set; }


        public int UserId { get; set; }
        public User? User { get; set; }
    }
}
