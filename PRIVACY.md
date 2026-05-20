# Privacy Policy

**Last Updated:** May 2026

Zarf ("we", "our", or "us") is a B2B corporate expense management application built for SMEs in the UAE and GCC region. This Privacy Policy describes how we collect, use, process, and safeguard your personal data when you use the Zarf Web Dashboard, Zarf Mobile App, and associated backend APIs.

---

## 1. Data We Collect
We collect only the minimal amount of personal data necessary to provision B2B corporate expense tracking services:

*   **Account Data:** Names, business email addresses, hashed passwords, and system roles (Admin, Manager, Employee).
*   **Transaction & Expense Data:** Transaction amounts, merchants, dates, expense categories, payment methods, VAT rates, and custom notes.
*   **Receipt Data:** Uploaded digital images of receipts or invoices.
*   **Device & Notification Data:** Securely stored Firebase Cloud Messaging (FCM) tokens to deliver push notifications for transaction approvals or rejections.

---

## 2. How Your Data is Used & Processed
We process your information strictly to execute the core services of the Zarf platform:
*   To authenticate your identity and enforce role-based access permissions.
*   To process and organize corporate expenses.
*   To parse receipt details (merchant, total, VAT) using automated AI services.
*   To calculate VAT compliance and generate analytics summaries.

---

## 3. Third-Party Data Handlers
To deliver specific features, we securely share minimal data payloads with the following third-party sub-processors:

*   **Cloudinary:** Uploaded receipt images are stored securely on Cloudinary.
*   **Groq API (AI Parsing):** When you scan a receipt, the image buffer is sent securely to Groq for automated AI OCR parsing. **No personal data shared with Groq is used to train public AI models.**
*   **Firebase (Google):** Device tokens are processed to trigger push notifications.

We do **not** sell, trade, rent, or monetize your personal or corporate data to any third-party marketing companies.

---

## 4. Where Your Data is Stored
All account data, expense documents, and company configurations are stored in secure cloud databases (MongoDB) configured and managed by your organization's designated workspace administrator.

---

## 5. Compliance & Your Rights (GDPR & UAE PDPL)
Whether you are located in the European Union (GDPR) or the United Arab Emirates (UAE Personal Data Protection Law - PDPL), you have strict rights regarding your personal data:

*   **Right to Access:** You can request a summary of all expenses and account data associated with your user ID.
*   **Right to Deletion:** You can request that your account be deleted.
*   **Right to Rectification:** You can update or correct your profile details at any time.
