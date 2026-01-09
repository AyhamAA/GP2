using Application.DTOs.Auth.Login;
using Application.DTOs.Auth.Password;
using Application.DTOs.Auth.Profile;
using Application.DTOs.Auth.Register;
using Application.Repositories.Interfaces;
using Application.Services.Interfaces;
using Application.Services.Interfaces.FileService;
using Domain.Entities;
using Domain.Entities.Enum;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Security.Cryptography;
using System.Text;

namespace Application.Services
{
    public class AuthService : IAuthService
    {
        private readonly IConfiguration _config;
        private readonly IGenericRepository<User> _userRepo;
        private readonly IGenericRepository<RefreshToken> _refreshTokenRepo;
        private readonly IHttpContextAccessor _httpContextAccessor;
        private readonly IFileStorageService _fileStorageService;
        public AuthService(IFileStorageService fileStorageService, IConfiguration config, IGenericRepository<User> userRepo, IHttpContextAccessor httpContextAccessor, IGenericRepository<RefreshToken> refreshTokenRepo)
        {
            _config = config;
            _userRepo = userRepo;
            _httpContextAccessor = httpContextAccessor;
            _refreshTokenRepo = refreshTokenRepo;
            _fileStorageService = fileStorageService;
        }

        public async Task<LoginResponseDto> LoginAsync(LoginRequestDto input)
        {
            // Explicit variable assignments
            string email = input.Email.Trim().ToLower();
            var user = await _userRepo.GetAll()
                  .FirstOrDefaultAsync(u =>
                      u.Email != null &&
                      u.Email.ToLower() == email);

            if (user == null)
            {
                return null;
            }

            // Explicit variable to keep hasher visible
            PasswordHasher<User> passwordHasher = new PasswordHasher<User>();
            string? storedHash = user.Password;
            string providedPassword = input.Password;
            
            // Check if password hash exists
            if (string.IsNullOrEmpty(storedHash))
            {
                return null;
            }
            
            // Explicit result variable
            PasswordVerificationResult passwordResult = passwordHasher.VerifyHashedPassword(
                user, 
                storedHash, 
                providedPassword);

            if (passwordResult == PasswordVerificationResult.Failed)
            {
                return null;
            }

            var accessToken = GenerateAccessToken(user);
            var refreshToken = GenerateRefreshToken();

            await _refreshTokenRepo.Insert(new RefreshToken
            {
                Token = refreshToken,
                UserId = user.UserId,
                Expires = DateTime.UtcNow.AddDays(7)
            });

            return new LoginResponseDto
            {
                UserId = user.UserId,
                FullName = user.FullName,
                Email = user.Email,
                Role = user.Role,
                AccessToken = accessToken,
                RefreshToken = refreshToken,
            };
        }

        public async Task<RegisterResponseDto> RegisterAsync(RegisterRequestDto input)
        {
            string email = input.Email.Trim().ToLower();
            var existingUser = await _userRepo.GetAll()
                .FirstOrDefaultAsync(u => u.Email!.Trim().ToLower() == email);

            if (existingUser != null)
                throw new InvalidOperationException("A user with this email already exists.");

            PasswordHasher<User> passwordHasher = new PasswordHasher<User>();
            string plainPassword = input.Password;

            var newUser = new User
            {
                FullName = input.FullName,
                Email = input.Email,
                Role = Role.User,
            };

            // Explicit hash variable
            string hashedPassword = passwordHasher.HashPassword(newUser, plainPassword);
            newUser.Password = hashedPassword;

            await _userRepo.Insert(newUser);
            await _userRepo.SaveChanges(); 

            return new RegisterResponseDto
            {
                UserId = newUser.UserId,
                FullName = newUser.FullName,
                Email = newUser.Email,
                Role = newUser.Role,
            };
        }

        public async Task ResetPassword(ResetPasswordDto input)
        {
            var userIdClaim = _httpContextAccessor.HttpContext?.User.FindFirstValue(ClaimTypes.NameIdentifier);
            if (userIdClaim == null)
                throw new UnauthorizedAccessException("User not authenticated");

            var userId = Convert.ToInt32(userIdClaim);
            var user = await _userRepo.GetById(userId);

            if (user == null)
                throw new Exception("User not found");

            PasswordHasher<User> passwordHasher = new PasswordHasher<User>();
            string? storedHash = user.Password;
            string oldPassword = input.OldPassword;
            
            if (string.IsNullOrEmpty(storedHash))
                throw new InvalidOperationException("User password is not set.");

            PasswordVerificationResult passwordResult = passwordHasher.VerifyHashedPassword(
                user, 
                storedHash, 
                oldPassword);

            if (passwordResult == PasswordVerificationResult.Failed)
            {
                throw new UnauthorizedAccessException("Old password is incorrect.");
            }

            string newPassword = input.NewPassword;
            string newHashedPassword = passwordHasher.HashPassword(user, newPassword);
            user.Password = newHashedPassword;
            
            _userRepo.Update(user);
            await _userRepo.SaveChanges();
        }

        public async Task<UserProfileDto> UserProfile()
        {
            var userIdClaim = _httpContextAccessor.HttpContext?
                .User.FindFirstValue(ClaimTypes.NameIdentifier);

            if (userIdClaim == null)
                throw new UnauthorizedAccessException("User not authenticated");

            var userId = Convert.ToInt32(userIdClaim);

            var user = await _userRepo.GetAll()
                .FirstOrDefaultAsync(u => u.UserId == userId && u.Role == Role.User);

            if (user == null)
                throw new Exception("User not found");

            return new UserProfileDto
            {
                FullName = user.FullName,
                Email = user.Email,
                GetProfileImage = user.ImageProfile
            };
        }


        public async Task UpdateUserProfileAsync(UserProfileDto dto)
        {
            var userIdClaim = _httpContextAccessor.HttpContext?
                .User.FindFirstValue(ClaimTypes.NameIdentifier);

            if (userIdClaim == null)
                throw new UnauthorizedAccessException("User not authenticated");

            var userId = Convert.ToInt32(userIdClaim);

            var user = await _userRepo.GetAll()
                .FirstOrDefaultAsync(u => u.UserId == userId && u.Role == Role.User);

            if (user == null)
                throw new Exception("User not found");

            if (dto.UploadProfileImage != null)
            {
                var imagePath = await _fileStorageService.UploadAsync(
                    new List<IFormFile> { dto.UploadProfileImage },
                    "ProfilePhotos/Users",
                    minFiles: 1,
                    maxFiles: 1
                );

                user.ImageProfile = imagePath.First();
            }

            user.FullName = dto.FullName;
            user.Email = dto.Email;

            _userRepo.Update(user);
            await _userRepo.SaveChanges();
        }


        public async Task<UserProfileDto> AdminProfile()
        {
            var userIdClaim = _httpContextAccessor.HttpContext?
                .User.FindFirstValue(ClaimTypes.NameIdentifier);

            if (userIdClaim == null)
                throw new UnauthorizedAccessException("User not authenticated");

            var userId = Convert.ToInt32(userIdClaim);

            var admin = await _userRepo.GetAll()
                .FirstOrDefaultAsync(u => u.UserId == userId && u.Role == Role.Admin);

            if (admin == null)
                throw new Exception("Admin not found");

            return new UserProfileDto
            {
                FullName = admin.FullName,
                Email = admin.Email,
            GetProfileImage = admin.ImageProfile
            };
        }

        public async Task UpdateAdminProfileAsync(UserProfileDto dto)
        {
            var userIdClaim = _httpContextAccessor.HttpContext?
                .User.FindFirstValue(ClaimTypes.NameIdentifier);

            if (userIdClaim == null)
                throw new UnauthorizedAccessException("User not authenticated");

            var userId = Convert.ToInt32(userIdClaim);

            var admin = await _userRepo.GetAll()
                .FirstOrDefaultAsync(u => u.UserId == userId && u.Role == Role.Admin);

            if (admin == null)
                throw new Exception("Admin not found");

            if (dto.UploadProfileImage != null)
            {
                var imagePath = await _fileStorageService.UploadAsync(
                    new List<IFormFile> { dto.UploadProfileImage },
                    "ProfilePhotos/Admins",
                    minFiles: 1,
                    maxFiles: 1
                );

                admin.ImageProfile = imagePath.First();
            }

            admin.FullName = dto.FullName;
            admin.Email = dto.Email;

            _userRepo.Update(admin);
            await _userRepo.SaveChanges();
        }


        public async Task<int> GetAllUsers()
        {
            return await _userRepo.GetAll().CountAsync();
        } 

        //=========================================================================================== For Token Generation
        public string GenerateAccessToken(User user)
        {
            // Explicit variables for debugging
            IConfigurationSection jwtSection = _config.GetSection("Jwt");
            string? jwtKey = jwtSection["Key"];
            if (string.IsNullOrEmpty(jwtKey))
                throw new InvalidOperationException("JWT Key is not configured.");

            byte[] keyBytes = Encoding.UTF8.GetBytes(jwtKey);
            SymmetricSecurityKey key = new SymmetricSecurityKey(keyBytes);

            string userId = user.UserId.ToString();
            string? fullName = user.FullName;
            string? email = user.Email;
            string role = user.Role.ToString();

            var claims = new List<Claim>
            {
                new Claim(ClaimTypes.NameIdentifier, userId),
                new Claim(ClaimTypes.Name, fullName ?? string.Empty),
                new Claim(ClaimTypes.Email, email ?? string.Empty),
                new Claim(ClaimTypes.Role, role),
            };

            string? issuer = jwtSection["Issuer"];
            string? audience = jwtSection["Audience"];

            var tokenDescriptor = new SecurityTokenDescriptor
            {
                Subject = new ClaimsIdentity(claims),
                Expires = DateTime.UtcNow.AddMinutes(15),
                Issuer = issuer,
                Audience = audience,
                SigningCredentials = new SigningCredentials(key, SecurityAlgorithms.HmacSha256)
            };

            JwtSecurityTokenHandler handler = new JwtSecurityTokenHandler();
            SecurityToken token = handler.CreateToken(tokenDescriptor);
            string tokenString = handler.WriteToken(token);
            return tokenString;
        }
        public string GenerateRefreshToken()
        {
            // Explicit variables for debugging
            byte[] random = new byte[64];
            RandomNumberGenerator.Fill(random);
            string refreshToken = Convert.ToBase64String(random);
            return refreshToken;
        }
        public async Task<string> RefreshToken(string refreshToken)
        {
            var userIdClaim = _httpContextAccessor.HttpContext?.User.FindFirstValue(ClaimTypes.NameIdentifier);
            if (userIdClaim == null)
                throw new UnauthorizedAccessException("User not authenticated");

            var userId = Convert.ToInt32(userIdClaim);

            var storedToken = _refreshTokenRepo.GetAll()
                .FirstOrDefault(rt => rt.UserId == userId && rt.Token == refreshToken && rt.Expires > DateTime.UtcNow);
            if (storedToken == null)
            {
                throw new SecurityTokenException("Invalid refresh token.");
            }
            var user = await _userRepo.GetById(storedToken.UserId);
            if (user == null)
                throw new Exception("User not found");
            
            return GenerateAccessToken(user);
        }

      
    }
}
