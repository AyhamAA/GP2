using Application.Repositories.Interfaces;
using Application.Services;
using Application.Services.Implementations;
using Application.Services.Interfaces;
using Application.Services.Interfaces.FileService;
using Infrastructure.FileService.Implementation;

using Infrastructure.Repositories;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.FileProviders;
using Microsoft.IdentityModel.Tokens;
using Microsoft.OpenApi.Models;
using System.Text;

var builder = WebApplication.CreateBuilder(args);

#region Controllers
builder.Services.AddControllers();
#endregion
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAll",
        policy =>
        {
            policy
                .AllowAnyOrigin()
                .AllowAnyMethod()
                .AllowAnyHeader();
        });
});
#region DbContext
builder.Services.AddDbContext<MedShareDbContext>(options =>
    options.UseSqlServer(
        builder.Configuration.GetConnectionString("Default")
    )
);
#endregion

#region HttpContext
builder.Services.AddHttpContextAccessor();
#endregion

#region JWT Authentication
var jwtSection = builder.Configuration.GetSection("Jwt");
var jwtKey = jwtSection["Key"]!;

builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
    .AddJwtBearer(options =>
    {
        options.TokenValidationParameters = new TokenValidationParameters
        {
            ValidateIssuer = true,
            ValidateAudience = true,
            ValidateIssuerSigningKey = true,
            ValidateLifetime = true,

            ValidIssuer = jwtSection["Issuer"],
            ValidAudience = jwtSection["Audience"],
            IssuerSigningKey = new SymmetricSecurityKey(
                Encoding.UTF8.GetBytes(jwtKey)
            ),

            ClockSkew = TimeSpan.Zero
        };
    });
#endregion

#region Swagger + JWT Support
builder.Services.AddSwaggerGen(c =>
{
    c.SwaggerDoc("v1", new OpenApiInfo
    {
        Title = "MedShare API",
        Version = "v1"
    });

    var securityScheme = new OpenApiSecurityScheme
    {
        Name = "Authorization",
        Description = "Enter JWT token like: Bearer {your token}",
        In = ParameterLocation.Header,
        Type = SecuritySchemeType.Http,
        Scheme = "bearer",
        BearerFormat = "JWT",
        Reference = new OpenApiReference
        {
            Type = ReferenceType.SecurityScheme,
            Id = "Bearer"
        }
    };


    c.AddSecurityDefinition("Bearer", securityScheme);

    c.AddSecurityRequirement(new OpenApiSecurityRequirement
    {
        {
            securityScheme,
            Array.Empty<string>()
        }
    });
});
#endregion

#region Dependency Injection
builder.Services.AddScoped(typeof(IGenericRepository<>), typeof(GenericRepository<>));

builder.Services.AddScoped<IAuthService, AuthService>();
builder.Services.AddScoped<IRequestService, RequestService>();
builder.Services.AddScoped<IDonationService, DonationService>();
builder.Services.AddScoped<ITaskService, TaskService>();
builder.Services.AddScoped<IFileStorageService, FileStorageService>();

#endregion

var app = builder.Build();

#region Database Seeding
using (var scope = app.Services.CreateScope())
{
    var context = scope.ServiceProvider.GetRequiredService<MedShareDbContext>();
    await SystemAdminSeedData.InitializeAsync(context);
}
#endregion

#region Middleware Pipeline
app.UseSwagger();
app.UseSwaggerUI();

app.UseHttpsRedirection();
app.UseStaticFiles();
app.UseStaticFiles(new StaticFileOptions
{
    FileProvider = new PhysicalFileProvider(
        Path.Combine(Directory.GetCurrentDirectory(), "Uploads")
    ),
    RequestPath = "/Uploads"
});
app.UseCors("AllowAll");
app.UseAuthentication();
app.UseAuthorization();
app.UseStaticFiles();
app.MapControllers();
#endregion

app.Run();
