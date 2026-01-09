using Application.DTOs.AllRequests.Donations;
using Application.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace MedShareAppAPI.Controllers
{
    [ApiController]
    [Route("api/donations")]
    public class DonationController : ControllerBase
    {
        private readonly IDonationService _donationService;

        public DonationController(IDonationService donationService)
        {
            _donationService = donationService;
        }


    
        [Authorize(Roles = "Admin")]
        [HttpPut("approveEquipment")]
        public async Task<IActionResult> ApproveEquipment([FromBody] ApproveDonationDto dto)
        {
            await _donationService.ApproveAssignEquipmentAsync(dto);
            return Ok("Donation approved");
        }

        [Authorize(Roles = "Admin")]
        [HttpPut("approveMedicine")]
        public async Task<IActionResult> ApproveMedicine([FromBody] ApproveDonationDto dto)
        {
            await _donationService.ApproveAssignMedicineAsync(dto);
            return Ok("Donation approved");
        }

        [Authorize(Roles = "Admin")]
        [HttpPut("rejectAssignDonation")]
        public async Task<IActionResult> RejectAssignDonation([FromBody] RequestRejectDonationDto dto)
        {
            await _donationService.RejectAssignRequestAsync(dto);
            return Ok("Donation rejected");
        }

        [Authorize]
        [HttpGet("available-equipment")]
        public async Task<IActionResult> GetAvailableEquipmentDonations()
        {
            var result = await _donationService.GetAvailableEquipmentDonationsAsync();
            return Ok(result);
        }

        [Authorize]
        [HttpGet("available-medicine")]
        public async Task<IActionResult> GetAvailableMedicineDonations()
        {
            var result = await _donationService.GetAvailableMedicineDonationsAsync();
            return Ok(result);
        }
 
        [Authorize(Roles = "Admin")]
        [HttpGet("getAllDonations")]
        public async Task<IActionResult> GetAllDonations()
        {
            return Ok(await _donationService.GetAllDonationsAsync());
        }
        [HttpGet("admin/pending-equipmenttake")]
        public async Task<IActionResult> GetPendingTakeEquipmentDonationRequestsAsync()
        {
            var result = await _donationService.GetPendingTakeEquipmentDonationRequestsAsync();
            return Ok(result);
        }
        [HttpGet("admin/pending-medicinetake")]
        public async Task<IActionResult> GetPendingTakeMedicineDonationRequestsAsync()
        {
            var result = await _donationService.GetPendingTakeMedicineDonationRequestsAsync();
            return Ok(result);
        }
    }


}
