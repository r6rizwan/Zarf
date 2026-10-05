# Zarf Web Dashboard 💻

React + Vite + Tailwind CSS web dashboard for Zarf managers and administrators.

## Features

- **Manager Review Queue:** Spreadsheet-style tabular view of submitted expenses with filtering (status, employee, category, date range) and sorting.
- **Expense Details & Audit:** Detailed view modal showing full expense records, receipt previews, **Vendor TRN** with format validation badges and quick links to the Federal Tax Authority (FTA) verification portal, and **Policy Flags**.
- **Company Settings & Spending Policies:** Full administrative panel to manage company profile (VAT rate, TRN, base currency) and configure automated corporate spending policies (`amount_limit`, `weekend_submission`) with `warn` or `block` enforcement actions.
- **Analytics & Reporting:** Interactive charts (monthly spend trends, spend by category, VAT summary breakdown) and CSV data exports.
- **Role Enforcement:** Blocks employee accounts from logging in, reserving web access exclusively for Managers and Admins.

## Tech Stack

- React 18, Vite, Tailwind CSS, Lucide icons
- TanStack Query (React Query) for async server state management
- Axios client with JWT authorization header interceptors
- Recharts for visual analytics

## Setup & Running

```bash
cp .env.example .env
npm install
npm run dev
```
