using Domain.Entities.Enum;
using System.ComponentModel.DataAnnotations;

namespace Domain.Entities
{
    public class DonationEquipment
    {
        [Key]
        public int DonationEquipmentId { get; set; }
        [Required(ErrorMessage = "This field is required"), StringLength(50, MinimumLength = 3, ErrorMessage = "Invalid Name.")]
        public string? ItemName { get; set; }
        public string? ItemDesc { get; set; }
        public bool IsAvailable { get; set; } 
        public AssignStatus AssignStatus { get; set; }
        public int Quantity { get; set; }
        public bool IsWokringFully { get; set; }
        public string? Image1 { get; set; }
        public string? Image2 { get; set; }
        public string? Image3 { get; set; }
        public int? UserAssignedTo { get; set; }
        public equStatus Condition { get; set; }
        public string? Accessories { get; set; }
        public DateTime CreationDate { get; set; }

        public bool AddedToCart { get; set; } = false;
        public int UserId { get; set; }
        public User? User { get; set; }

    }
}
