using Application.DTOs.Auth.Login;
using Application.DTOs.Auth.Password;
using Application.DTOs.Auth.Profile;
using Application.DTOs.Auth.Register;
using Application.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

[Route("api/[controller]")]
[ApiController]

public class AuthController : ControllerBase
{
    private readonly IAuthService _authService;

    public AuthController(IAuthService authService)
    {
        _authService = authService;
    }

    [HttpPost("Login")]
    public async Task<IActionResult> Login([FromBody] LoginRequestDto input)
    {
        var response = await _authService.LoginAsync(input);
        if (response == null)
            return Unauthorized("Invalid email or password.");

        return Ok(response);
    }

    [HttpPost("Register")]
    public async Task<IActionResult> Register([FromBody] RegisterRequestDto input)
    {
        var response = await _authService.RegisterAsync(input);
        if (response == null)
            return BadRequest("Cannot Register.");

        return Ok(response);
    }

    [HttpPost("ResetPassword")]
    [Authorize]
    public async Task<IActionResult> ResetPassword([FromBody] ResetPasswordDto input)
    {
        await _authService.ResetPassword(input);
        return Ok();
    }

    [Authorize(Roles = "User")]
    [HttpGet("ProfileUser")]
    public async Task<IActionResult> UserProfile()
    {
        var response = await _authService.UserProfile();
        if (response == null)
            return Unauthorized();

        return Ok(response);
    }

    [Authorize(Roles = "User")]
    [HttpPut("user")]
    [Consumes("multipart/form-data")]
    public async Task<IActionResult> UpdateUserProfile([FromForm] UserProfileDto dto)
    {
        await _authService.UpdateUserProfileAsync(dto);
        return Ok("User profile updated successfully");
    }

    [Authorize(Roles = "Admin")]
    [HttpGet("ProfileAdmin")]
    public async Task<IActionResult> AdminProfile()
    {
        var response = await _authService.AdminProfile();
        if (response == null)
            return Unauthorized();

        return Ok(response);
    }

    [Authorize(Roles = "Admin")]
    [HttpPut("admin")]
    [Consumes("multipart/form-data")]
    public async Task<IActionResult> UpdateAdminProfile([FromForm] UserProfileDto dto)
    {
        await _authService.UpdateAdminProfileAsync(dto);
        return Ok("Admin profile updated successfully");
    }

    [Authorize(Roles = "Admin")]
    [HttpGet("getAllUsers")]
    public async Task<IActionResult> GetAllUsers()
    {
        var response = await _authService.GetAllUsers();
        return Ok(response);
    }

}
