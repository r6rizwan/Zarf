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

### Flutter
```bash
cd zarf_mobile
flutter pub get
flutter run
```

### React
```bash
cd zarf_web
cp .env.example .env
npm install
npm run dev
```

## Seed Data
```bash
cd zarf_backend
node src/scripts/seed.js
# admin@zarf.demo / Admin@1234
```

## Demo
- APK: [GitHub Releases link](https://github.com/r6rizwan/Zarf/releases)
- Web: [Vercel link](https://vercel.com)

## Notes
- VAT rate is company-configurable — not hardcoded anywhere
- All Flutter layouts use DirectionalityAware alignment
- Arabic RTL localization is in the roadmap
