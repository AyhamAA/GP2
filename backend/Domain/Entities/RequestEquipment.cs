using Domain.Entities.Enum;
using System.ComponentModel.DataAnnotations;

namespace Domain.Entities
{
    public class RequestEquipment
    {
        [Key]
        public int RequestEquipmentId { get; set; }
        public string ItemName { get; set; }
        public string? ItemDesc { get; set; }
        public bool IsAvailable { get; set; }
        public string? Image1 { get; set; }
        public string Image2 { get; set; }
        public string Image3 { get; set; }
        public bool IsWokringFully { get; set; }
        public int Quantity { get; set; }
        public equStatus Condition { get; set; }
        public string Accessories { get; set; }
        public DateTime CreationDate { get; set; }
        public StatusDonation? Status { get; set; } = StatusDonation.Pending;
        public int UserId { get; set; }
        public User? User { get; set; }

    }
}
