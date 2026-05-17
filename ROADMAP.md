# Zarf — Development Roadmap

> Track what's planned, what's in progress, and what's done.
> Update this file at the end of every build session.

---

## Project Overview
Full-stack corporate expense management app targeting UAE/GCC market.
- **Mobile:** Flutter (employee + manager)
- **Backend:** Node.js + Express + MongoDB
- **Web:** React dashboard (finance + admin)
- **AI:** Groq API for receipt parsing
- **Market:** UAE, Saudi Arabia, GCC — VAT configurable per company

---

## Status Legend
- [ ] Not started
- [~] In progress
- [x] Done

---

## Phase 1 — Backend Foundation + Flutter Core
> Goal: Working auth, expense submission, and approval flow. No AI, no React, no analytics yet.

### Backend
- [x] Project setup: Node v20, Express, MongoDB, folder structure, .gitignore
- [x] .env + .env.example with all keys
- [x] env.js — startup validation, throws on missing keys
- [x] CORS config — CLIENT_URL from env, credentials: true
- [x] Global error handler middleware — registered last in server.js
- [x] General rate limiter — 100 req/15min/IP via express-rate-limit
- [x] API versioning — all routes under /api/v1/
- [x] Company model — name, baseCurrency, vatRegistered, vatRate, vatNumber
- [x] User model — name, email, passwordHash, role, companyId, fcmToken
- [x] Expense model — all fields, status state machine
- [x] Auth routes — POST /api/v1/auth/register, /login, /refresh
- [x] bcrypt password hashing — min 8 chars, 1 uppercase, 1 number, 1 special char
- [x] JWT auth — access token 15m, refresh token 7d with rotation
- [x] Refresh token rotation — old token invalidated on each refresh
- [x] authMiddleware — verify JWT, attach req.user
- [x] roleGuard — roleGuard('manager', 'admin')
- [x] Expense CRUD — GET (paginated), POST, GET/:id, PATCH/:id/status, DELETE/:id
- [x] Pagination contract — page & limit params, { data, total, page, totalPages }

### Flutter
- [x] Project setup: Flutter, Riverpod, GoRouter, Dio, folder structure, .gitignore
- [x] google-services.json + GoogleService-Info.plist excluded from git
- [x] Dio axiosClient — JWT attach + 401 auto-refresh interceptor
- [x] AuthRepo — login, register, refresh, logout
- [x] GoRouter — role-based redirect on login
- [x] LoginScreen
- [x] HomeScreen — quick stats placeholder
- [x] AddExpenseSheet — amount, category, date, notes, paymentMethod,
                        currency dropdown, VAT toggle (rate from Company API)
- [x] MyExpensesScreen — paginated list, filter by status/date/category
- [x] ApprovalQueueScreen — manager only, approve/reject with comment
- [x] ExpenseDetailScreen — view fields + status
- [x] All layouts use start/end alignment (RTL-ready)

---

## Phase 2 — AI + Currency
> Goal: Receipt scanning works. Expenses auto-convert to company base currency.

### Backend
- [x] AI rate limiter — 10 req/min/IP, applied only to parse-receipt route
- [x] multer setup — temp file upload, auto-cleanup after Cloudinary upload
- [x] Cloudinary config — uploads go to /zarf/receipts/ folder, named by expenseId
- [x] groqService — image buffer → Groq prompt → { merchant, amount, date, currency }
- [x] POST /api/v1/expenses/parse-receipt — multer + AI limiter + groqService
- [x] currencyService — exchangerate-api.com free tier, convert any currency to
                        company baseCurrency on every expense save
- [x] Expense POST updated — auto-convert amount to baseCurrency before saving

### Flutter
- [x] ReceiptScanScreen — camera capture → multipart POST to parse-receipt
                          → pre-fill AddExpenseSheet with parsed fields
- [x] receipt_ai_service.dart — multipart Dio upload, parse response
- [x] currency_service.dart — fetch live rates, convert display amounts

---

## Phase 3 — React Web Dashboard
> Goal: Finance and admin can view, approve, and export expenses from browser.

### Backend
- [x] Analytics routes under /api/v1/analytics/
- [x] GET /analytics/summary — total spend, pending count, approved total, total VAT
- [x] GET /analytics/by-category — spend grouped by category, current month
- [x] GET /analytics/by-employee — spend grouped by userId, current month
- [x] GET /analytics/vat-report — total claimable VAT, uses company vatRate
- [x] PATCH /api/v1/company/:id — update company settings (admin only)

### React
- [x] Project setup: Vite + React + Tailwind + shadcn/ui, .gitignore
- [x] axiosClient — JWT attach + 401 refresh + redirect interceptor
- [x] Zustand authStore with persist middleware
- [x] ProtectedRoute — role check, redirect logic
- [x] LoginPage — wired to authStore
- [x] Sidebar + TopBar layout
- [x] DashboardPage — StatCards, MonthlySpendChart, SpendByCategoryChart,
                       VATSummaryCard (shows actual vatRate from API)
- [x] ExpensesPage — paginated ExpenseTable, FilterBar, ApproveRejectModal
- [x] ExportCSVButton — papaparse, exports current filtered result set
- [x] EmployeesPage — employee list, spend per person this month
- [x] SettingsPage — vatRate numeric input, PATCH company on save,
                     invalidates all analytics React Query cache after save

---

## Phase 4 — Polish + Deploy
> Goal: Demoable, documented, recruiter-ready.

### Backend
- [x] Seed script — 1 admin, 2 managers, 5 employees, 1 company (vatRate: 5),
                    30 days of randomized expenses across categories + statuses
- [x] Bruno/Postman collection — all /api/v1/ routes with example request bodies
- [ ] Deploy to Railway or Render (free tier)

### Flutter
- [x] FCM push notifications — on expense approved/rejected
- [~] App icon + splash screen
- [~] Build release APK — attach to GitHub releases

### React
- [ ] Deploy to Vercel (free tier)
- [ ] Update CORS CLIENT_URL to Vercel domain

### Repo
- [x] README.md — project overview, UAE/GCC fintech context, setup instructions
                   for all 3 parts, .env.example reference, APK download link,
                   RTL-ready note, VAT configurable note, live demo links
- [x] ASCII architecture diagram in README
- [x] All three .gitignore files verified — .env and secrets never committed

---

## Known Limitations (be honest in README)
- Receipt OCR accuracy depends on image quality and Groq model
- Currency rates cached — not real-time tick data
- No multi-tenancy isolation at DB level (single MongoDB instance)
- Arabic/RTL UI not built yet — architecture is RTL-ready

---

## Deferred (Post-Portfolio)
- Arabic RTL full localization
- Multi-tenant DB isolation
- QuickBooks / Zoho Books integration
- Recurring expense detection
- Budget limits per department
- iOS App Store + Google Play submission
