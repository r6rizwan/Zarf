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
- Employee expense submission with receipt scanning
- AI-powered receipt parsing via Groq
- Manager approval workflow
- VAT-aware (configurable rate — UAE 5%, Saudi 15%, full GCC coverage)
- Multi-currency with live AED conversion
- React web dashboard with analytics
- RTL-ready architecture (Arabic localization in roadmap)

## Tech Stack
| Layer | Tech |
|-------|------|
| Mobile | Flutter, Riverpod, Dio, GoRouter |
| Backend | Node.js v20, Express, MongoDB, Mongoose |
| Web | React, Tailwind, shadcn/ui, Recharts |
| AI | Groq API (receipt OCR) |
| Storage | Cloudinary |
| Auth | JWT with refresh token rotation |

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
To compile a release build with a custom output name (`zarf.apk`) ready for distribution, run the automated pipeline from the root folder:
```bash
./build_apk.sh
```
This automatically handles cache cleaning, package updates, and compiles the release binary to:
📂 **`build_artifacts/zarf.apk`**

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
