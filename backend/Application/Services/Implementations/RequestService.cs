using Application.DTOs.AllRequests.Requests;
using Application.DTOs.AllRequests.Requests.Carts;
using Application.Repositories.Interfaces;
using Application.Services.Interfaces;
using Application.Services.Interfaces.FileService;
using Domain.Entities;
using Domain.Entities.Enum;
using Microsoft.AspNetCore.Http;
using Microsoft.EntityFrameworkCore;
using System.Security.Claims;

namespace Application.Services.Implementations
{
    public class RequestService : IRequestService
    {
        private readonly IGenericRepository<RequestEquipment> _requestEquipmentRepo;
        private readonly IGenericRepository<RequestMedicine> _requestMedicineRepo;
        private readonly IGenericRepository<RequestAssign> _requestAssignRepo;
        private readonly IGenericRepository<DonationEquipment> _donationEquipmentRepo;
        private readonly IGenericRepository<DonationMedicine> _donationMedicineRepo;
        private readonly IGenericRepository<CartItem> _cartRepo;
        private readonly IGenericRepository<User> _userRepo;
        private readonly IFileStorageService _fileStorageService;
        private readonly IHttpContextAccessor _httpContextAccessor;

        public RequestService(
            IGenericRepository<RequestEquipment> requestEquipmentRepo,
            IGenericRepository<RequestMedicine> requestMedicineRepo,
            IGenericRepository<DonationEquipment> donationEquipmentRepo,
            IGenericRepository<DonationMedicine> donationMedicineRepo,
            IFileStorageService fileStorageService, IGenericRepository<User> userRepo,
            IHttpContextAccessor httpContextAccessor,
            IGenericRepository<CartItem> cartRepo,
            IGenericRepository<RequestAssign> requestAssignRepo
            )
        {
            _requestEquipmentRepo = requestEquipmentRepo;
            _requestMedicineRepo = requestMedicineRepo;
            _donationEquipmentRepo = donationEquipmentRepo;
            _donationMedicineRepo = donationMedicineRepo;
            _fileStorageService = fileStorageService;
            _userRepo = userRepo;
            _httpContextAccessor = httpContextAccessor;
            _cartRepo = cartRepo;
            _requestAssignRepo = requestAssignRepo;
        }

        public async Task CreateEquipmentRequestAsync(RequestUploadEquipmentDto dto)
        {
            var imagePaths = await _fileStorageService.UploadAsync(
                            dto.Images,
                            "Uploads/Requests/Equipments",
                            minFiles: 1,
                            maxFiles: 3
                        );
            var userId = Convert.ToInt32(
              _httpContextAccessor.HttpContext!
                  .User.FindFirstValue(ClaimTypes.NameIdentifier)!
          );
            var request = new RequestEquipment
            {
               
                ItemName = dto.ItemName,
                ItemDesc = dto.ItemDesc,
                Quantity = dto.Quantity,
                Condition = (equStatus)dto.Condition,
                Accessories = dto.Accessories!,
                IsAvailable = dto.IsAvailable,
                IsWokringFully=dto.IsWokringFully,
                UserId = userId,
                CreationDate = DateTime.UtcNow,
                Status = StatusDonation.Pending,
                 Image1 = imagePaths.Count > 0 ? imagePaths[0] : null,
                 Image2 = imagePaths.Count > 1 ? imagePaths[1] : null,
                 Image3 = imagePaths.Count > 2 ? imagePaths[2] : null,
             };

            await _requestEquipmentRepo.Insert(request);
            await _requestEquipmentRepo.SaveChanges();
        }

        public async Task CreateMedicineRequestAsync(RequestUploadMedicineDto dto)
        {
            var imagePaths = await _fileStorageService.UploadAsync(
                           dto.Images,
                           "Uploads/Requests/Medicines",
                           minFiles: 1,
                           maxFiles: 3
                       );
            var userId = Convert.ToInt32(
             _httpContextAccessor.HttpContext!
                 .User.FindFirstValue(ClaimTypes.NameIdentifier)!
         );
            var request = new RequestMedicine
            {
                ItemName = dto.ItemName,
                ItemDesc = dto.ItemDesc,
                Quantity = dto.Quantity,
                Strength = dto.Strength,
                DosageForm = (DosageForm)dto.DosageForm,
                ExpirationDate = dto.ExpirationDate,
                UnOpend = dto.UnOpend,
                IsAvailable = dto.IsAvailable,
                UserId = userId,
                CreationDate = DateTime.UtcNow,
                Status = StatusDonation.Pending,
                Image1 = imagePaths.Count > 0 ? imagePaths[0] : null,
                Image2 = imagePaths.Count > 1 ? imagePaths[1] : null,
                Image3 = imagePaths.Count > 2 ? imagePaths[2] : null,
            };

            await _requestMedicineRepo.Insert(request);
            await _requestMedicineRepo.SaveChanges();
        }

        public async Task ApproveEquipmentRequestAsync(RequestDto dto)
        {
            var request = await _requestEquipmentRepo.GetById(dto.RequestId);
            if (request == null) throw new Exception("Request not found");

            var donation = new DonationEquipment
            {
                ItemName = request.ItemName,
                ItemDesc = request.ItemDesc,
                Quantity = request.Quantity,
                Condition = request.Condition,
                Accessories = request.Accessories,
                IsAvailable = request.IsAvailable,
                IsWokringFully=request.IsWokringFully,
                UserId = request.UserId,
                CreationDate = DateTime.UtcNow,
                Image1 = request.Image1,
                Image2 = request.Image2,
                Image3 = request.Image3
            };

            await _donationEquipmentRepo.Insert(donation);

            request.Status = StatusDonation.Approved;

            await _donationEquipmentRepo.SaveChanges();
            await _requestEquipmentRepo.SaveChanges();
        }

        public async Task ApproveMedicineRequestAsync(RequestDto dto)
        {
            var request = await _requestMedicineRepo.GetById(dto.RequestId);
            if (request == null) throw new Exception("Request not found");
           
            var donation = new DonationMedicine
            {
                ItemName = request.ItemName,
                ItemDesc = request.ItemDesc,
                Quantity = request.Quantity,
                Strength = request.Strength,
                DosageForm = request.DosageForm!,
                ExpirationDate = request.ExpirationDate!,
                UnOpend = request.UnOpend ?? true,
                IsAvailable = request.IsAvailable,
                UserId = request.UserId,
                CreationDate = DateTime.UtcNow,
              
                Image1 = request.Image1,
                Image2 = request.Image2,
                Image3 = request.Image3,
            };

            await _donationMedicineRepo.Insert(donation);

            request.Status = StatusDonation.Approved;

            await _donationMedicineRepo.SaveChanges();
            await _requestMedicineRepo.SaveChanges();
        }

        public async Task RejectEquipmentRequestAsync(RequestDto dto)
        {
            var request = await _requestEquipmentRepo.GetById(dto.RequestId);
            if (request == null) throw new Exception("Request not found");

            request.Status = StatusDonation.Rejected;
            await _requestEquipmentRepo.SaveChanges();
        }

        public async Task RejectMedicineRequestAsync(RequestDto dto)
        {
            var request = await _requestMedicineRepo.GetById(dto.RequestId);
            if (request == null) throw new Exception("Request not found");

            request.Status = StatusDonation.Rejected;
            await _requestMedicineRepo.SaveChanges();
        }

        public async Task<List<AdminDonationRequestDto>> GetPendingEquipmentRequests()
        {
            var userId = Convert.ToInt32(
            _httpContextAccessor.HttpContext!
                .User.FindFirstValue(ClaimTypes.NameIdentifier)!
        );
            return await _requestEquipmentRepo.GetAll().Include(e=>e.User)
                .Where(e => e.Status == StatusDonation.Pending && e.UserId==userId)
                .Select(e => new AdminDonationRequestDto
                {
                    ItemName = e.ItemName,
                    UserId = e.UserId,
                    UserName = e.User.FullName,
                    UserEmail = e.User.Email,
                    Quantity = e.Quantity,
                    ExpirationDate = null,
                    RequestId=e.RequestEquipmentId
                })
                .ToListAsync();
        }

        public async Task<List<AdminDonationRequestDto>> GetPendingMedicineRequests()
        {
            var userId = Convert.ToInt32(
        _httpContextAccessor.HttpContext!
            .User.FindFirstValue(ClaimTypes.NameIdentifier)!
    );
            return await _requestMedicineRepo.GetAll().Include(e => e.User)
                .Where(e => e.Status == StatusDonation.Pending && e.UserId == userId)
                .Select(e => new AdminDonationRequestDto
                {
                    ItemName = e.ItemName,
                    UserId = e.UserId,
                    UserName = e.User.FullName,
                    UserEmail = e.User.Email,
                    Quantity = e.Quantity,
                    ExpirationDate = null,
                    RequestId=e.RequestMedicineId
                })
                .ToListAsync();
        }

        public async Task<List<DonationRequestStatusDto>> GetUnavailableEquipmentRequests()
        {
            return await _requestEquipmentRepo.GetAll()
                .Where(r => !r.IsAvailable)
                .Select(r => new DonationRequestStatusDto
                {
                    ItemName = r.ItemName,
                    Status = r.Status.Value
                })
                .ToListAsync();
        }

        public async Task<List<DonationRequestStatusDto>> GetUnavailableMedicineRequests()
        {
            return await _requestMedicineRepo.GetAll()
                .Where(r => !r.IsAvailable)
                .Select(r => new DonationRequestStatusDto
                {
                    ItemName = r.ItemName,
                    Status = r.Status.Value
                })
                .ToListAsync();
        }

        public async Task<int> AllUnavailableDonationRequests()
        {
            var eq = await GetUnavailableEquipmentRequests();
            var med = await GetUnavailableMedicineRequests();

            return eq.Count + med.Count;
        }

        public async Task AddEquipmentToCartAsync(AddToCartDto dto)
        {
            var donation = await _donationEquipmentRepo.GetById(dto.DonationId);
            var userIdClaim = _httpContextAccessor.HttpContext.User.FindFirstValue(ClaimTypes.NameIdentifier);
            var userId = Convert.ToInt32(userIdClaim);

            var user = await _userRepo.GetById(userId);

            if (user == null) throw new Exception("User not found");

            if (donation == null) throw new Exception("Donation not found");

            if(donation.AddedToCart) throw new Exception("Donation already in cart");

            if(donation.UserId == user.UserId) throw new Exception("Cannot add your own donation to cart");
           
            if(dto.Quantity > donation.Quantity) throw new Exception("Requested quantity exceeds available quantity");

            var addtoCart= new CartItem { 
                    DonationEquipmentId = donation.DonationEquipmentId,
                    UserId = user.UserId,
                    Quantity = dto.Quantity,
                    ItemName = dto.ItemName,
                    ItemType = CartType.Equipment
                   };

            donation.AddedToCart = true;
            _donationEquipmentRepo.Update(donation);

            await  _cartRepo.Insert(addtoCart);
            await _cartRepo.SaveChanges();
        }

        public async Task AddMedicineToCartAsync(AddToCartDto dto)
        {
            var donation = await _donationMedicineRepo.GetById(dto.DonationId);
            var userIdClaim = _httpContextAccessor.HttpContext.User.FindFirstValue(ClaimTypes.NameIdentifier);
            var userId = Convert.ToInt32(userIdClaim);

            var user = await _userRepo.GetById(userId);

            if (user == null) throw new Exception("User not found");

            if (donation == null) throw new Exception("Donation not found");

            if (donation.AddedToCart) throw new Exception("Donation already in cart");

            if (donation.UserId == user.UserId) throw new Exception("Cannot add your own donation to cart");

            if (dto.Quantity > donation.Quantity) throw new Exception("Requested quantity exceeds available quantity");
            var addtoCart = new CartItem
            {
               DonationMedicineId = donation.DonationMedicineId,
                UserId = user.UserId,
                Quantity = dto.Quantity,
                ItemName= dto.ItemName,
                ItemType = CartType.Medicine
            };

            donation.AddedToCart = true;
            _donationMedicineRepo.Update(donation);

            await _cartRepo.Insert(addtoCart);
            await _cartRepo.SaveChanges();
        }

        public async Task RemoveItemFromCartAsync(AddToCartDto dto)
        {
            var userIdClaim = _httpContextAccessor.HttpContext.User.FindFirstValue(ClaimTypes.NameIdentifier);
            var userId = Convert.ToInt32(userIdClaim);
            var addedToCartItem = await _cartRepo.GetAll()
                .FirstOrDefaultAsync(c => c.UserId == userId && 
                    ((c.ItemType == CartType.Equipment && c.DonationEquipmentId == dto.DonationId) ||
                     (c.ItemType == CartType.Medicine && c.DonationMedicineId == dto.DonationId)));
            
            if (addedToCartItem == null) throw new Exception("Item not found in cart");

            // Reset AddedToCart flag on donation
            if (addedToCartItem.ItemType == CartType.Equipment)
            {
                var donation = await _donationEquipmentRepo.GetById(addedToCartItem.DonationEquipmentId);
                if (donation != null)
                {
                    donation.AddedToCart = false;
                    _donationEquipmentRepo.Update(donation);
                }
            }
            else if (addedToCartItem.ItemType == CartType.Medicine)
            {
                var donation = await _donationMedicineRepo.GetById(addedToCartItem.DonationMedicineId);
                if (donation != null)
                {
                    donation.AddedToCart = false;
                    _donationMedicineRepo.Update(donation);
                }
            }

            await _cartRepo.Delete(addedToCartItem);
            await _cartRepo.SaveChanges();
        }


        public async Task CheckoutAsync()
        {
            var userId = Convert.ToInt32(
                _httpContextAccessor.HttpContext!
                    .User.FindFirstValue(ClaimTypes.NameIdentifier)!
            );

            var cartItems = await _cartRepo.GetAll()
                .Where(c => c.UserId == userId).ToListAsync();

            if (!cartItems.Any())
                throw new Exception("Cart is empty");

            foreach (var item in cartItems)
            {
                int donationId = item.ItemType == CartType.Equipment
                    ? item.DonationEquipmentId: item.DonationMedicineId;

                var requestAssign = new RequestAssign
                {
                    DonationId = donationId,
                    Quantity = item.Quantity,
                    UserId = userId,
                    Status = AssignStatus.Pending,

                };

                await _requestAssignRepo.Insert(requestAssign);
            }

            // Reset AddedToCart flags
            foreach (var item in cartItems)
            {
                if (item.ItemType == CartType.Equipment)
                {
                    var donation = await _donationEquipmentRepo.GetById(item.DonationEquipmentId);
                    if (donation != null)
                    {
                        donation.AddedToCart = false;
                        _donationEquipmentRepo.Update(donation);
                    }
                }
                else if (item.ItemType == CartType.Medicine)
                {
                    var donation = await _donationMedicineRepo.GetById(item.DonationMedicineId);
                    if (donation != null)
                    {
                        donation.AddedToCart = false;
                        _donationMedicineRepo.Update(donation);
                    }
                }
            }

            foreach (var item in cartItems)
            {
              await  _cartRepo.Delete(item);
            }

            await _requestAssignRepo.SaveChanges();
            await _cartRepo.SaveChanges();
        }

        public async Task<CartItemResponseDto> GetMyCartAsync()
        {
            var userId = Convert.ToInt32(
                _httpContextAccessor.HttpContext!
                    .User.FindFirstValue(ClaimTypes.NameIdentifier)!
            );

            var cartItems = await _cartRepo.GetAll()
                .Where(c => c.UserId == userId)
                .Include(c => c.DonationEquipment)
                .Include(c => c.DonationMedicine)
                .ToListAsync();

            var result = new CartItemResponseDto();

            foreach (var item in cartItems)
            {
                if (item.ItemType == CartType.Equipment && item.DonationEquipment != null)
                {
                    result.Equipment.Add(new CartItemRequestDto
                    {
                        DonationId = item.DonationEquipmentId,
                        ItemName = item.DonationEquipment.ItemName,
                        Quantity = item.Quantity,
                        CartType = CartType.Equipment,
                    });
                }
                else if (item.ItemType == CartType.Medicine && item.DonationMedicine != null)
                {
                    result.Medicine.Add(new CartItemRequestDto
                    {
                        DonationId = item.DonationMedicineId,
                        ItemName = item.DonationMedicine.ItemName,
                        Quantity = item.Quantity,
                        CartType = CartType.Medicine
                    });
                }
            }

            return result;
        }

        public async Task<int> GetUnavailableCountAsync()
        {
            return await _requestEquipmentRepo.GetAll()
                   .Where(r => !r.IsAvailable)
                   .CountAsync()
                 + await _requestMedicineRepo.GetAll()
                   .Where(r => !r.IsAvailable)
                   .CountAsync();
        }

        public async Task<int> GetPendingCountAsync()
        {
            return await _requestEquipmentRepo.GetAll()
                   .Where(r => r.Status == StatusDonation.Pending)
                   .CountAsync()
                 + await _requestMedicineRepo.GetAll()
                   .Where(r => r.Status == StatusDonation.Pending)
                   .CountAsync();
        }
        public async Task<List<AdminDonationRequestDto>> GetAdminDonationRequestsAsync()
        {
            var equipment = await _requestEquipmentRepo.GetAll()
                .Include(r => r.User)
                .Where(r => r.Status == StatusDonation.Pending)
                .Select(r => new AdminDonationRequestDto
                {
                    RequestId = r.RequestEquipmentId,
                    ItemName = r.ItemName,
                    Quantity = r.Quantity,
                    UserId = r.UserId,
                    UserName = r.User.FullName,
                    UserEmail = r.User.Email,
                    ExpirationDate = null,
                    Type = "Equipment"
                })
                .ToListAsync();

            var medicine = await _requestMedicineRepo.GetAll()
                .Include(r => r.User)
                .Where(r => r.Status == StatusDonation.Pending)
                .Select(r => new AdminDonationRequestDto
                {
                    RequestId = r.RequestMedicineId,
                    ItemName = r.ItemName,
                    Quantity = r.Quantity,
                    UserId = r.UserId,
                    UserName = r.User.FullName,
                    UserEmail = r.User.Email,
                    ExpirationDate = r.ExpirationDate,
                    Type = "Medicine"
                })
                .ToListAsync();

            return equipment.Concat(medicine).ToList();
        
    }
}

}
