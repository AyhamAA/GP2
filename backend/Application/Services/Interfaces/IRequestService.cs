using Application.DTOs.AllRequests.Requests;
using Application.DTOs.AllRequests.Requests.Carts;

namespace Application.Services.Interfaces
{
    public interface IRequestService
    {
        Task CreateEquipmentRequestAsync(RequestUploadEquipmentDto dto);
        Task CreateMedicineRequestAsync(RequestUploadMedicineDto dto);

        Task ApproveEquipmentRequestAsync(RequestDto dto);
        Task ApproveMedicineRequestAsync(RequestDto dto);

        Task RejectEquipmentRequestAsync(RequestDto dto);
        Task RejectMedicineRequestAsync(RequestDto dto);

        Task<List<AdminDonationRequestDto>> GetPendingEquipmentRequests();
        Task<List<AdminDonationRequestDto>> GetPendingMedicineRequests();

        Task<List<DonationRequestStatusDto>> GetUnavailableEquipmentRequests();
        Task<CartItemResponseDto> GetMyCartAsync();
        Task<List<DonationRequestStatusDto>> GetUnavailableMedicineRequests();
        Task<List<AdminDonationRequestDto>> GetAdminDonationRequestsAsync();

        Task AddEquipmentToCartAsync(AddToCartDto dto);
        Task AddMedicineToCartAsync(AddToCartDto dto);
        Task RemoveItemFromCartAsync(AddToCartDto dto);
        Task CheckoutAsync();
        Task<int> GetUnavailableCountAsync();
        Task<int> GetPendingCountAsync();
        Task<int> AllUnavailableDonationRequests();
    }
}
