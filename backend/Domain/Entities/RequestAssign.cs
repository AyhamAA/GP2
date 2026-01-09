using Domain.Entities.Enum;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Domain.Entities
{
    public class RequestAssign
    {
        [Key]
        public int RequestAssignId { get; set; }
        public int DonationId { get; set; }
        public DonationEquipment DonationEquipment { get; set; }
        public DonationMedicine DonationMedicine { get; set; }
        public int Quantity { get; set; }
        public int UserId { get; set; }
        [ForeignKey("UserId")]
        public User? User { get; set; }
        public AssignStatus? Status { get; set; } = AssignStatus.Pending;
    }
}
