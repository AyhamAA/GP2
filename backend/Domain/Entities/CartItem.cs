
namespace Domain.Entities
{
    public class CartItem
    {

        public int CartItemId { get; set; }
        public string ItemName { get; set; }
        public int Quantity { get; set; }
        public CartType ItemType { get; set; } // "Medicine" or "Equipment"

        public int UserId { get; set; }
        public User? User { get; set; }

        public int DonationEquipmentId { get; set; }
        public DonationEquipment? DonationEquipment { get; set; }

        public int DonationMedicineId { get; set; }
        public DonationMedicine? DonationMedicine { get; set; }

    }
    public enum  CartType
    {
        Medicine=2,
        Equipment=1
    }
}
