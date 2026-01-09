using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Application.DTOs.AllRequests.Requests
{
    public class AdminDonationRequestDto
    {
        public int RequestId { get; set; }
        public string ItemName { get; set; }
        public int Quantity { get; set; }
        public DateTime? ExpirationDate { get; set; }

        public int UserId { get; set; }
        public string UserName { get; set; }
        public string UserEmail { get; set; }

        public string Type { get; set; } // Equipment / Medicine
    }
}
