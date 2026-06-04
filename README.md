# Zarf — Corporate Expense Management

> B2B expense tracking app for UAE/GCC SMEs.  
> Flutter mobile + React web dashboard + Node.js API with AI receipt parsing.

## Architecture

```text
                 +---------------------+
                 |  Flutter Mobile App |
                 +----------+----------+
                            |
                            | REST / JWT
                            v
+----------------+   +------+---------------------+   +-------------------+
| React Web App  +-->| Node.js + Express API     +-->| MongoDB           |
| (Manager/Admin)|   | (Auth, Expenses, Analytics)|   | (Users/Expenses)  |
+----------------+   +------+---------------------+   +-------------------+
                            |
                            +---------------------> Groq API (Receipt Parsing)
                            |
                            +---------------------> Cloudinary (Receipt Upload)
```

## Features
- **AI-Powered Receipt Scanning:** OCR and entity extraction using Groq's high-speed **Llama 4 Scout** vision model.
- **Multi-Parameter Extraction:** Automatically extracts and populates Merchant, Amount, Currency, Date, **Category classification**, and **VAT/Tax details** directly from photo assets.
- **Smart VAT Toggling:** Instantly detects if tax was charged, flips the VAT switch to ON in the UI, and fills the exact tax amount.
- **Image Compression Engine:** Scaler on mobile compressing raw photos to 1024x1024 / 85% quality, reducing network transfer payloads from 12MB down to ~150KB.
- **Free-Tier Performance Optimizations:** Health-check keep-alive pinging, compressed API responses, lean Mongo reads, trimmed expense-list payloads, and in-memory mobile caching to reduce Render cold-start pain.
- **Premium UX Polish:** Smooth soft-keyboard dismissals via active focus releases on login and submission sheets.
- **Manager Queues:** Real-time review lanes to Approve or Reject transactions with custom comments.
- **Push Notifications:** Instant FCM push alerts delivered to employee devices when a manager approves or rejects their expense claim.
- **VAT-Aware Architecture:** Fully configurable VAT rates (UAE 5%, Saudi 15%, etc.) with live AED currency conversion.

[Explore the full Product Roadmap & Completed Milestones here!](ROADMAP.md)

## Role & Platform Separation
Zarf is structured with a strict, multi-tenant B2B separation of concerns across platforms:

*   **📱 Flutter Mobile App (Employee & Manager Focus):**
    *   **Employees:** Submit expenses, snap pictures of physical receipts for instant AI-powered OCR parsing, and monitor reimbursement statuses.
    *   **Managers & Admins:** Access a dedicated fourth tab for review queues to quickly Approve or Reject transactions with custom comments on the go, alongside their personal dashboards.
*   **💻 React Web App (Manager & Admin Focus):**
    *   **Employees:** Are **blocked** from logging in (directed to the native mobile experience).
    *   **Managers:** Audit expenses in a tabular spreadsheet, perform reviews, and export CSVs.
    *   **Admins:** Have unrestricted access, including the employee spending directory and core settings (VAT rate adjustments, base currency changes, TRN settings).

## Tech Stack
| Layer | Tech |
|-------|------|
| Mobile | Flutter, Riverpod, Dio, GoRouter |
| Backend | Node.js v20, Express, MongoDB, Mongoose |
| Web | React, Tailwind, shadcn/ui, Recharts |
| AI | Groq API (Llama 4 Scout Vision Model) |
| Storage | Cloudinary (Secure Storage Sessions) |
| Auth | JWT with Refresh Token rotation |

## 🔒 Security & Data Privacy
Zarf prioritizes enterprise-grade security and user privacy across all architectural integrations:

*   **☁️ Cloudinary Secure Storage:** Uploaded physical receipts are stored securely on Cloudinary. These image assets are fully private and accessible only via authorized backend-to-client secure sessions.
*   **🤖 Groq AI Receipt Parsing:** Receipt images are processed securely using the Groq API. **Zero personal data or transaction info shared with Groq is stored, logged, or utilized to train public AI models.**
*   **🔔 Firebase Cloud Messaging (FCM):** Device tokens are securely managed and processed strictly to deliver real-time push notifications when transaction statuses change.
*   **🛡️ Hardened Backend API:** Configured with a global rate-limiter, a strict separate AI cost-limiter, custom production-mode error sanitization (stack traces are never leaked), and a complete set of standard secure HTTP response headers (CSP, HSTS, XSS protection, MIME protection).

## Project Structure
```text
zarf/
├── zarf_backend/
├── zarf_mobile/
└── zarf_web/
```

## Setup

### Backend
```bash
cd zarf_backend
cp .env.example .env   # fill in your values
npm install
npm run dev
```

Required backend env keys:
- `PORT`, `MONGO_URI`
- `JWT_SECRET`, `JWT_REFRESH_SECRET`, `JWT_EXPIRES_IN`, `JWT_REFRESH_EXPIRES_IN`
- `CLIENT_URL`
- `GROQ_API_KEY`, `CLOUDINARY_URL`, `CURRENCY_API_KEY`
- `FIREBASE_PROJECT_ID`, `FIREBASE_CLIENT_EMAIL`, `FIREBASE_PRIVATE_KEY`

### Flutter
```bash
cd zarf_mobile
flutter pub get
flutter run
```

#### Automated Production Builds (Custom APK)
To compile a release build with a custom versioned name (e.g., `zarf-v1.0.0.apk`) ready for distribution, run the automated pipeline from the root folder:
```bash
./build_apk.sh
```
This automatically handles cache cleaning, package updates, and compiles the release binary to:
📂 **`build_artifacts/zarf-v<version>.apk`**

Firebase (Android):
- Package name is `com.zarf.mobile`
- Place Firebase config at `zarf_mobile/android/app/google-services.json`

### React
```bash
cd zarf_web
cp .env.example .env
npm install
npm run dev
```

React env:
- `VITE_API_URL=http://localhost:3000/api/v1` (or deployed backend URL)

## Seed Data
```bash
cd zarf_backend
node src/scripts/seed.js
```

### 🔑 Demo Credentials
Recruiters and reviewers can use the following pre-seeded test accounts to explore the role-based features of the Zarf platform:

| Role | Email | Password | Allowed Capabilities |
|------|-------|----------|----------------------|
| **Admin** | `admin@zarf.demo` | `Admin@1234` | Full access, settings edit (VAT configurations), finance dashboard |
| **Manager** | `manager1@zarf.demo` | `Manager@1234` | Approve/Reject expense queues, view personal home dashboard |
| **Employee** | `employee1@zarf.demo` | `Employee@1234` | Submit expenses, receipt AI OCR scanning, view personal history |

*(Employee accounts range from `employee1` to `employee5`, and managers range from `manager1` to `manager2`)*

## Demo
- Web App: [Live Dashboard](https://zarf-cyan.vercel.app)
- API Backend: [Render API](https://zarf-backend.onrender.com)
- APK: [GitHub Releases link](https://github.com/r6rizwan/Zarf/releases)

## Notes
- VAT rate is company-configurable — not hardcoded anywhere
- All Flutter layouts use DirectionalityAware alignment
- Arabic RTL localization is in the roadmap
- Mobile expense lists auto-refresh (polling + app resume + return from detail)
- Nested stateful navigation (StatefulShellRoute tab caching) preventing redundant API re-fetching and preserving UI scroll positions
- Mobile networking uses in-memory auth token caching, short-lived list caching, and GET retry/backoff for unstable connections
- Home screen prioritizes fast first paint by rendering recent expenses first and loading manager-only approval counts after
- Backend includes `/api/v1/health`, response compression, lean read queries, and smaller expense-list payloads for better free-tier performance
