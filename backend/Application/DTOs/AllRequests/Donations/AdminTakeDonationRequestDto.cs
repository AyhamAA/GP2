using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Application.DTOs.AllRequests.Donations
{
    public class AdminTakeDonationRequestDto
    {
        public int DonationId { get; set; }
        public string ItemName { get; set; }
        public int Quantity { get; set; }

        public int UserId { get; set; }
        public string UserName { get; set; }
        public string UserEmail { get; set; }

        public string Type { get; set; } // Equipment | Medicine
        public DateTime? ExpirationDate { get; set; } // فقط للدواء
    }
}
