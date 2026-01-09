# GP2 / MedShare

This repo contains:
- `backend/`: ASP.NET Core Web API
- `frontend/`: Flutter app

## Backend (ASP.NET Core)

- The API is served under `/api`.
- Static files for uploads are served under `/Uploads` (e.g. `/Uploads/...`).

### Configuration (recommended)

Use environment variables for secrets:

- `Jwt__Key`: JWT signing key (required; production must NOT use placeholder)
- `SeedAdmin__Password` or `MEDSHARE_SEED_ADMIN_PASSWORD`: admin seed password
- `SeedAdmin__Emails__0`, `SeedAdmin__Emails__1`, ... or `MEDSHARE_SEED_ADMIN_EMAILS` (comma-separated)
- `Cors__AllowedOrigins__0`, `Cors__AllowedOrigins__1`, ... (production CORS allow-list)

Run (example):

```bash
cd backend/MedShareAppAPI
dotnet run
```

## Frontend (Flutter)

See `frontend/README.md` for API base URL configuration (`API_BASE_URL`) and run commands.

# GP2 / MedShare

This repo contains:
- `backend/`: ASP.NET Core Web API
- `frontend/`: Flutter app

## Backend (ASP.NET Core)

- The API is served under `/api`.
- Static files for uploads are served under `/Uploads` (e.g. `/Uploads/...`).

### Configuration (recommended)

Use environment variables for secrets:

- `Jwt__Key`: JWT signing key (required; production must NOT use placeholder)
- `SeedAdmin__Password` or `MEDSHARE_SEED_ADMIN_PASSWORD`: admin seed password
- `SeedAdmin__Emails__0`, `SeedAdmin__Emails__1`, ... or `MEDSHARE_SEED_ADMIN_EMAILS` (comma-separated)
- `Cors__AllowedOrigins__0`, `Cors__AllowedOrigins__1`, ... (production CORS allow-list)

Run (example):

```bash
cd backend/MedShareAppAPI
dotnet run
```

## Frontend (Flutter)

See `frontend/README.md` for API base URL configuration (`API_BASE_URL`) and run commands.


