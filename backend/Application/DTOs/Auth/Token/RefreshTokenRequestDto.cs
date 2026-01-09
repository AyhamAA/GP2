namespace Application.DTOs.Auth.Token
{
    public sealed class RefreshTokenRequestDto
    {
        public int UserId { get; set; }
        public string RefreshToken { get; set; } = string.Empty;
    }
}


