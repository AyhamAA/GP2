# Changes made (by AI agent)

This file summarizes the modifications applied during the “enhance everything” pass.

## Backend (ASP.NET Core)

### Security + correctness

- **Protected endpoints**
  - Added missing auth guard on cart endpoint:
    - `GET /api/requests/myCart` now requires `[Authorize(Roles = "User")]`.
  - Locked down admin donation endpoints:
    - `GET /api/donations/admin/pending-equipmenttake` now requires admin.
    - `GET /api/donations/admin/pending-medicinetake` now requires admin.
  - `POST /api/Auth/ResetPassword` now requires `[Authorize]`.

- **Fixed incorrect API messages**
  - `PUT /api/requests/checkoutMyCart` now returns **“Checkout completed successfully”** (was “Medicine added to cart”).
  - `PUT /api/requests/removeFromCart` now returns **“Item removed from cart”** (was “Equipment removed from cart”).

- **Refresh tokens actually persist**
  - After inserting a refresh token on login, the service now calls `SaveChanges()`.

### Error handling upgrades

- **Global exception middleware**
  - Added a global middleware that converts exceptions into `application/problem+json` responses with a `traceId`.
  - Added conservative exception → status-code mapping (e.g., 401/404/409/400/500).

- **More accurate exception types**
  - Replaced many `throw new Exception("...")` patterns in services with:
    - `KeyNotFoundException` → 404
    - `InvalidOperationException` → 409
    - `ArgumentException` → 400
  - Result: fewer “random 500s”, more correct API responses.

### Data correctness

- Fixed backend response for admin “take donation” requests:
  - Ensured DTO `Type` is set to `"Equipment"` / `"Medicine"`.
  - Fixed incorrect include for medicine take requests (`DonationMedicine` instead of `DonationEquipment`).

### Production-safe configuration

- **CORS**
  - Switched from always-open CORS to:
    - Dev: open CORS
    - Prod: only enabled if `Cors:AllowedOrigins` is configured

- **JWT key**
  - Replaced committed JWT key with a placeholder and added runtime checks to avoid using it in production.

- **Admin seeding**
  - Removed hardcoded admin password/email list.
  - Now reads from configuration or environment variables; in production it requires explicit configuration.

## Frontend (Flutter)

### Networking consistency

- **Cart service migrated from `http` to Dio**
  - `CartService` now uses `ApiClient.dio` (auth interceptor + consistent base URL + consistent error handling).

- **Fixed wrong admin endpoints**
  - `AdminHomeService` now calls the correct backend routes:
    - pending upload requests from `/requests/admin/pending-requests` (then filtered by `type`)
    - take requests from `/donations/admin/pending-...`

### Base URL + images

- **Configurable API base URL**
  - Added `API_BASE_URL` support via `--dart-define` with a default.
  - Added sensible Dio timeouts.

- **No more hardcoded `10.0.2.2` for images**
  - Added `ApiClient.publicUrl(...)` to convert server paths like `/Uploads/...` into absolute URLs.
  - Updated image/profile screens to use `ApiClient.publicUrl(...)`.

## Documentation

- Added root `README.md` with backend/frontend overview and env var guidance.
- Updated `frontend/README.md` with:
  - `API_BASE_URL` run examples (Android emulator vs desktop/iOS)
  - notes about auth header + image URL construction

## Files changed / added

### Added
- `backend/MedShareAppAPI/Middleware/ApiExceptionMiddleware.cs`
- `README.md`
- `CHANGES.md`

### Updated
- `backend/MedShareAppAPI/Program.cs`
- `backend/MedShareAppAPI/Controllers/RequestsController.cs`
- `backend/MedShareAppAPI/Controllers/DonationsController.cs`
- `backend/MedShareAppAPI/Controllers/AuthController.cs`
- `backend/MedShareAppAPI/appsettings.json`
- `backend/Infrastructure/Data/SystemAdminSeedData.cs`
- `backend/Application/Services/Implementations/AuthService.cs`
- `backend/Application/Services/Implementations/RequestService.cs`
- `backend/Application/Services/Implementations/DonationService.cs`
- `backend/Application/Services/Implementations/TaskService.cs`
- `frontend/lib/core/api/api_client.dart`
- `frontend/lib/features/auth/data/Cart/cart_service.dart`
- `frontend/lib/features/auth/data/adminhome/admin_home_service.dart`
- `frontend/lib/screens/dr_DonorandRequester/dr_home_screen.dart`
- `frontend/lib/screens/dr_DonorandRequester/dr_profile_screen.dart`
- `frontend/lib/screens/Admin/admin_profile_screen.dart`
- `frontend/README.md`


