using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Application.DTOs.AllRequests.Donations
{
    public class ApproveDonationDto
    {
        public int DonationId { get; set; }
        public int Quantity { get; set; }
        public int ReceiverUserId { get; set; }
    }

}
