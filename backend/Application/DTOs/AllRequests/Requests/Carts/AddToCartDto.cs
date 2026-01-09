using Domain.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Application.DTOs.AllRequests.Requests.Carts
{
    public class AddToCartDto
    {
        public int DonationId { get; set; }
        public string ItemName { get; set; }
        public int Quantity { get; set; }
        public CartType CartType { get; set; }
    }
    public class CartItemRequestDto
    {
        public int DonationId { get; set; }
        public string ItemName { get; set; }
        public int Quantity { get; set; }
        public CartType CartType { get; set; }
    }
    public class CartItemResponseDto
    {
        public List<CartItemRequestDto> Equipment { get; set; } = new();
        public List<CartItemRequestDto> Medicine { get; set; } = new();
    }
}
