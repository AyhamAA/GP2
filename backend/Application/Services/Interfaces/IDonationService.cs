using Application.DTOs.AllRequests.Donations;

namespace Application.Services.Interfaces
{
    public interface IDonationService
    {

        Task ApproveAssignEquipmentAsync(ApproveDonationDto dto);
        Task ApproveAssignMedicineAsync(ApproveDonationDto dto);
        Task RejectAssignRequestAsync(RequestRejectDonationDto dto);
        Task<List<AdminTakeDonationRequestDto>> GetPendingTakeEquipmentDonationRequestsAsync();
        Task<List<AdminTakeDonationRequestDto>> GetPendingTakeMedicineDonationRequestsAsync();
        Task<int> GetAllDonationsAsync();
        Task<List<AvailableDonationDto>> GetAvailableEquipmentDonationsAsync();
        Task<List<AvailableDonationDto>> GetAvailableMedicineDonationsAsync();
    }


}
