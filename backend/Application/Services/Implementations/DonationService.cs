using Application.DTOs.AllRequests.Donations;
using Application.Repositories.Interfaces;
using Application.Services.Interfaces;
using Domain.Entities;
using Domain.Entities.Enum;
using Microsoft.AspNetCore.Http;
using Microsoft.EntityFrameworkCore;
using System.Security.Claims;

namespace Application.Services.Implementations
{
    public class DonationService : IDonationService
    {
        private readonly IGenericRepository<DonationEquipment> _equipmentRepo;
        private readonly IGenericRepository<DonationMedicine> _medicineRepo;
        private readonly IGenericRepository<RequestAssign> _requestAssignRepo;
        private readonly IGenericRepository<CartItem> _cartRepo;
        private readonly IHttpContextAccessor _httpContextAccessor;
        
        public DonationService(
            IGenericRepository<DonationEquipment> equipmentRepo,
            IGenericRepository<DonationMedicine> medicineRepo,
            IGenericRepository<RequestAssign> requestAssignRepo,
            IGenericRepository<CartItem> cartRepo,
            IHttpContextAccessor httpContextAccessor)
        {
            _equipmentRepo = equipmentRepo;
            _medicineRepo = medicineRepo;
            _requestAssignRepo = requestAssignRepo;
            _cartRepo = cartRepo;
            _httpContextAccessor = httpContextAccessor;
        }



        public async Task ApproveAssignEquipmentAsync(ApproveDonationDto dto)
        {

            var donation = await _equipmentRepo.GetById(dto.DonationId);

            if (donation == null)
                throw new Exception("Donation not found");

            var requestAssigns = await _requestAssignRepo.GetAll()
                .Where(r => r.DonationId == dto.DonationId &&
                       r.UserId == dto.ReceiverUserId).ToListAsync();

            if (!requestAssigns.Any())
                throw new Exception("No request found for this donation");

            var requestedQuantity = requestAssigns.Sum(r => r.Quantity);

            if (requestedQuantity > donation.Quantity)
                throw new Exception("Requested quantity exceeds available quantity");

            if (donation.UserAssignedTo != null)
                throw new Exception("Donation already assigned");

            donation.Quantity -= requestedQuantity;
            donation.AssignStatus = AssignStatus.AssigningApproved;
            donation.IsAvailable = donation.Quantity > 0;
            donation.UserId= dto.ReceiverUserId;
            _equipmentRepo.Update(donation);
            await _equipmentRepo.SaveChanges();
            await _requestAssignRepo.SaveChanges();
        }

        public async Task ApproveAssignMedicineAsync(ApproveDonationDto dto)
        {

            var donation = await _medicineRepo.GetById(dto.DonationId);

            var requestAssigns = await _requestAssignRepo.GetAll()
              .Where(r => r.DonationId == dto.DonationId &&
                     r.UserId == dto.ReceiverUserId).ToListAsync();

            if (!requestAssigns.Any())
                throw new Exception("No request found for this donation");

            var requestedQuantity = requestAssigns.Sum(r => r.Quantity);

            if (requestedQuantity > donation.Quantity)
                throw new Exception("Requested quantity exceeds available quantity");

            if (donation.UserId != null)
                throw new Exception("Donation already assigned");

            donation.Quantity -= requestedQuantity;
            donation.AssignStatus = AssignStatus.AssigningApproved;
            donation.IsAvailable = donation.Quantity > 0;
            donation.UserId = dto.ReceiverUserId;
            _medicineRepo.Update(donation);
            await _medicineRepo.SaveChanges();
            await _requestAssignRepo.SaveChanges();
        }

        public async Task RejectAssignRequestAsync(RequestRejectDonationDto dto)
        {
            var requestAssign = await _requestAssignRepo.GetAll()
                .FirstOrDefaultAsync(r =>
                    r.DonationId == dto.DonationId &&
                    r.UserId == dto.UserId &&
                    r.Status == AssignStatus.Pending);

            if (requestAssign == null)
                throw new Exception("Pending request not found for this user");

            requestAssign.Status = AssignStatus.AssigningRejected;

            _requestAssignRepo.Update(requestAssign);
            await _requestAssignRepo.SaveChanges();
        }


        public async Task<int> GetAllDonationsAsync()
        {
            var equipmentCount = await _equipmentRepo.GetAll().CountAsync();
            var medicineCount = await _medicineRepo.GetAll().CountAsync();

            return equipmentCount + medicineCount;
        }
        public async Task<List<AdminTakeDonationRequestDto>> GetPendingTakeEquipmentDonationRequestsAsync()
        {
            return await _requestAssignRepo.GetAll().Include(u => u.User).Include(u => u.DonationEquipment).Where(u=>u.Status == AssignStatus.Pending).Select(e => new AdminTakeDonationRequestDto
            {
                UserId = e.UserId,
                UserName = e.User.FullName,
                UserEmail = e.User.Email,
                DonationId = e.DonationId,
                ItemName = e.DonationEquipment.ItemName,
                Quantity = e.DonationEquipment.Quantity,
                ExpirationDate=null,
            }).ToListAsync();
        }
        public async Task<List<AdminTakeDonationRequestDto>> GetPendingTakeMedicineDonationRequestsAsync()
        {
            return await _requestAssignRepo.GetAll().Include(u => u.User).Include(u => u.DonationEquipment).Where(u => u.Status == AssignStatus.Pending).Select(e => new AdminTakeDonationRequestDto
            {
                UserId = e.UserId,
                UserName = e.User.FullName,
                UserEmail = e.User.Email,
                DonationId = e.DonationId,
                ItemName = e.DonationMedicine.ItemName,
                ExpirationDate=e.DonationMedicine.ExpirationDate,
                Quantity = e.DonationMedicine.Quantity,
            }).ToListAsync();

        }

        public async Task<List<AvailableDonationDto>> GetAvailableEquipmentDonationsAsync()
        {
            var userIdClaim = _httpContextAccessor.HttpContext?.User.FindFirstValue(ClaimTypes.NameIdentifier);
            var userId = userIdClaim != null ? Convert.ToInt32(userIdClaim) : 0;

            // Get all cart items for this user to check which donations are in their cart
            var userCartItemIds = await _cartRepo.GetAll()
                .Where(c => c.UserId == userId && c.ItemType == CartType.Equipment)
                .Select(c => c.DonationEquipmentId)
                .ToListAsync();

            // Get all available donations that are not added to any cart OR are in the current user's cart
            var donations = await _equipmentRepo.GetAll()
                .Where(d => d.IsAvailable && d.UserId != userId && 
                    (!d.AddedToCart || userCartItemIds.Contains(d.DonationEquipmentId)))
                .Select(d => new AvailableDonationDto
                {
                    DonationId = d.DonationEquipmentId,
                    ItemName = d.ItemName ?? string.Empty,
                    ItemDesc = d.ItemDesc,
                    Quantity = d.Quantity,
                    Image1 = d.Image1,
                    Image2 = d.Image2,
                    Image3 = d.Image3,
                    ExpirationDate = null,
                    AddedToCart = userCartItemIds.Contains(d.DonationEquipmentId),
                    CreationDate = d.CreationDate
                })
                .ToListAsync();

            return donations;
        }

        public async Task<List<AvailableDonationDto>> GetAvailableMedicineDonationsAsync()
        {
            var userIdClaim = _httpContextAccessor.HttpContext?.User.FindFirstValue(ClaimTypes.NameIdentifier);
            var userId = userIdClaim != null ? Convert.ToInt32(userIdClaim) : 0;

            // Get all cart items for this user to check which donations are in their cart
            var userCartItemIds = await _cartRepo.GetAll()
                .Where(c => c.UserId == userId && c.ItemType == CartType.Medicine)
                .Select(c => c.DonationMedicineId)
                .ToListAsync();

            // Get all available donations that are not added to any cart OR are in the current user's cart
            var donations = await _medicineRepo.GetAll()
                .Where(d => d.IsAvailable && d.UserId != userId && 
                    (!d.AddedToCart || userCartItemIds.Contains(d.DonationMedicineId)))
                .Select(d => new AvailableDonationDto
                {
                    DonationId = d.DonationMedicineId,
                    ItemName = d.ItemName,
                    ItemDesc = d.ItemDesc,
                    Quantity = d.Quantity,
                    Image1 = d.Image1,
                    Image2 = d.Image2,
                    Image3 = d.Image3,
                    ExpirationDate = d.ExpirationDate,
                    AddedToCart = userCartItemIds.Contains(d.DonationMedicineId),
                    CreationDate = d.CreationDate,
                    Strength = d.Strength
                })
                .ToListAsync();

            return donations;
        }

    }

}
