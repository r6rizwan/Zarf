# Zarf Mobile — B2B Expense Tracking

A premium, responsive, and performance-optimized Flutter application designed for real-time corporate expense tracking, receipt AI scanning, and on-the-go manager approval workflows.

---

## 🚀 Key Features & Adaptability

Zarf Mobile dynamically shifts its UI components and layouts depending on the logged-in user's role:

*   **📱 Standard Employees:**
    *   **3-Tab Layout:** Dashboard (Home), Expense History, and Profile.
    *   **AI OCR Scanning:** Take photos of receipts to auto-fill amount, currency, merchant, and dates instantly via Groq API.
    *   **VAT & Multi-Currency:** Dynamic UAE (5%) / GCC VAT toggles, live AED conversion rates, and clean numeric formatting (e.g., `AED 1,000.00`).
*   **💼 Managers & Admins:**
    *   **4-Tab Layout:** Dynamically adds a dedicated **Approvals** tab while preserving the main "Home" personal dashboard.
    *   **On-the-go Reviews:** Instantly Approve or Reject pending team transactions with custom notes, responsive success feedback (visual SnackBars), and automated keyboard handling.

---

## 🛠️ Tech Stack & Libraries

*   **Core:** Flutter (Material 3 standard)
*   **Routing & State Navigation:** `GoRouter` + `StatefulShellRoute.indexedStack` (Tab-caching nested navigation that prevents redundant page rebuilds and maintains scroll states).
*   **State Management:** Riverpod (`flutter_riverpod`) ready.
*   **HTTP client:** `Dio` (fully equipped with JWT attachments and automatic 401 token refresh interceptors).
*   **Storage:** Secure local storage (`flutter_secure_storage`).

---

## 📂 Project Structure

```text
lib/
├── core/
│   ├── router/      # GoRouter navigation & StatefulShellRoute configurations
│   └── theme/       # Premium Teal-600 color system & Material 3 tokens
├── data/
│   ├── models/      # Immutable models (User, Expense, Company)
│   ├── repositories/# Auth & Expense API repository layers
│   └── services/    # Secure Storage, Dio Client, Notifications, Receipt AI
└── features/        # Feature-driven screen blocks
    ├── add_expense/ # Expense submission sheet with AI fillers
    ├── approval/    # Manager pending review list
    ├── auth/        # Premium Welcome/Login flow
    ├── expense_detail/ # Polished expense overview & action sheet
    ├── home/        # Main Scaffold & personal spent analytics cards
    ├── my_expenses/ # Paginated history list with infinite scrolling
    ├── profile/     # User metrics & logout controls
    └── receipt_scan/# Camera capture & parser loader
```

---

## ⚡ Setup & Run

### Prerequisites
*   Flutter SDK installed (Channel stable)
*   Active Android/iOS Emulator or physical device connected

### 1. Fetch Dependencies
Navigate to the directory and run pub get:
```bash
cd zarf_mobile
flutter pub get
```

### 2. Configure API Endpoint
The mobile app is configured to communicate directly with your live Render backend in [api_service.dart](lib/data/services/api_service.dart):
```dart
static const _baseUrl = 'https://zarf-backend.onrender.com/api/v1';
```

### 3. Run Development Server
```bash
flutter run
```

---

## 📦 Automated Release Compilation

To compile a release build with a custom named output (`zarf.apk`) ready for recruiters, run the build pipeline from the **Zarf root directory**:

```bash
./build_apk.sh
```
This automatically cleans all caches, fetches latest dependencies, compiles the release APK, and outputs it safely to:
📂 **`build_artifacts/zarf.apk`**

*(Note: `build_artifacts/` is ignored by Git in the root `.gitignore` to prevent repository bloat).*

---

## 🔍 Static Code Quality

Check static code health and formatting standards before pushing commits:
```bash
flutter analyze
```
All code compiled passes with **zero warnings and zero errors**.
