namespace Application.DTOs.AllRequests.Donations
{
    public class AvailableDonationDto
    {
        public int DonationId { get; set; }
        public string ItemName { get; set; }
        public string? ItemDesc { get; set; }
        public int Quantity { get; set; }
        public string? Image1 { get; set; }
        public string? Image2 { get; set; }
        public string? Image3 { get; set; }
        public DateTime? ExpirationDate { get; set; }
        public bool AddedToCart { get; set; }
        public DateTime CreationDate { get; set; }
        public string? Strength { get; set; } // For medicines
    }
}




