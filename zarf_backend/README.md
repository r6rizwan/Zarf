# Zarf Backend API ⚡

Node.js + Express + MongoDB REST API for the Zarf Corporate Expense Management platform.

## Architecture & Features

- **Authentication & Security:** Hardened JWT authentication with token rotation, bcrypt password hashing, role-based route guards (`employee`, `manager`, `admin`), Express rate limiting, and security headers (Helmet-like policy).
- **AI Receipt Parsing:** Integrated Groq API using **Llama 4 Scout Vision** (`meta-llama/llama-4-scout-17b-16e-instruct`) for multimodal receipt OCR, extracting merchant, date, amount, currency, category, VAT, and **Vendor TRN**.
- **TRN Tax Validation:** Format validation service for UAE (15 digits, starting with 1) and Saudi Arabia (15 digits, starting with 3) Tax Registration Numbers.
- **Corporate Policy Engine:** CRUD endpoints `/api/v1/policies` for managing spending rules (`amount_limit`, `weekend_submission`). Automated enforcement at expense submission time (`warn` flags expense, `block` rejects submission).
- **Currency Conversion:** Exchange rate integration using external currency API with caching.
- **Notifications:** Firebase Admin SDK (FCM) integration for real-time push alerts on expense approvals/rejections.

## Project Structure

```text
src/
├── config/        # Environment variables and DB connection
├── controllers/   # Auth, Expense, Company, User, Analytics, Policy
├── middleware/    # Auth, Role Guard, Rate Limiter, Error Handler, Security, Upload
├── models/        # Mongoose schemas (User, Company, Expense, Policy)
├── routes/        # Express router definitions
├── scripts/       # Seed script for initial setup
└── services/      # Currency, FCM, Groq AI, TRN validation
```

## API Endpoints Summary

- `POST /api/v1/auth/login`, `POST /api/v1/auth/refresh`, `POST /api/v1/auth/logout`
- `GET /api/v1/expenses`, `POST /api/v1/expenses`, `POST /api/v1/expenses/parse-receipt`
- `GET /api/v1/expenses/:id`, `PATCH /api/v1/expenses/:id/status`, `DELETE /api/v1/expenses/:id`
- `GET /api/v1/company/:id`, `PATCH /api/v1/company/:id`
- `GET /api/v1/policies`, `POST /api/v1/policies`, `PATCH /api/v1/policies/:id`, `DELETE /api/v1/policies/:id`
- `GET /api/v1/analytics/summary`, `GET /api/v1/analytics/category`, `GET /api/v1/analytics/vat`
- `GET /api/v1/users`, `POST /api/v1/users`

## Setup & Running

```bash
cp .env.example .env
npm install
npm run dev
```
