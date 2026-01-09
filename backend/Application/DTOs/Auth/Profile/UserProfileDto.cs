
using Microsoft.AspNetCore.Http;

namespace Application.DTOs.Auth.Profile
{
    public class UserProfileDto
    {
        public string FullName { get; set; }
        public string Email { get; set; }
        public IFormFile? UploadProfileImage { get; set; }
        public string? GetProfileImage { get; set; }
    }
}
