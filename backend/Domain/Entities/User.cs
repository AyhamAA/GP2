using Domain.Entities.Enum;
using System.ComponentModel.DataAnnotations;
namespace Domain.Entities
{
    public class User
    {
        [Key]
        public int UserId { get; set; }

        [Required,StringLength(50,MinimumLength =3,ErrorMessage ="Invalid Name.")]
        public string? FullName { get; set; }

        [Required, EmailAddress, StringLength(70, MinimumLength = 10, ErrorMessage = "Invalid Email.")]
        public string? Email { get; set; }

        [MaxLength(500)]
        public string? Password { get; set; }

        public string? ImageProfile { get; set; }
        public Role Role { get; set; }
        public ICollection<DonationEquipment>? MyDonationEquipments { get; set; }
        public ICollection<DonationMedicine>? MyDonationMedicines { get; set; }
        public ICollection<RequestMedicine>? MyRequestMedicines { get; set; }
        public ICollection<RequestEquipment>? MyRequestEquipments { get; set; }
        public ICollection<RequestAssign>? RequestAssigns { get; set; }

    }

}
