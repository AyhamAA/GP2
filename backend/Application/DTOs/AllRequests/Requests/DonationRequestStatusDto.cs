using Domain.Entities.Enum;

namespace Application.DTOs.AllRequests.Requests
{
    public class DonationRequestStatusDto
    {
        public string ItemName { get; set; }

        public StatusDonation Status { get; set; }
    }

}
