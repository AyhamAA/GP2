using Application.Repositories.Interfaces;
using Application.Services.Interfaces;
using Domain.Entities;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

[Authorize(Roles = "Admin")]
[ApiController]
[Route("api/[controller]")]
public class AnalysisController : ControllerBase
{
    private readonly IGenericRepository<User> _userRepo;
    private readonly IDonationService _donationService;
    private readonly IRequestService _requestService;

    public AnalysisController(
        IGenericRepository<User> userRepo,
        IDonationService donationService,
        IRequestService requestService)
    {
        _userRepo = userRepo;
        _donationService = donationService;
        _requestService = requestService;
    }

    [HttpGet]
    public async Task<IActionResult> GetAnalysis()
    {
        return Ok(new
        {
            users = await _userRepo.GetAll().CountAsync(),
            donations = await _donationService.GetAllDonationsAsync(),
            requests = await _requestService.GetUnavailableCountAsync(),
            userRequests = await _requestService.GetPendingCountAsync()
        });
    }
}
