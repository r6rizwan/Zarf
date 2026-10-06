import { useState } from 'react';
import { useAuthStore } from '../../store/authStore';
import { LogOut } from 'lucide-react';

export default function TopBar({ title }) {
  const { clearAuth } = useAuthStore();
  const [showLogoutConfirmation, setShowLogoutConfirmation] = useState(false);

  return (
    <>
      <header className="sticky top-0 z-40 h-16 shrink-0 bg-white border-b border-slate-200 flex items-center justify-between px-6">
        <h1 className="text-lg font-semibold text-slate-800">{title}</h1>

        <button
          type="button"
          onClick={() => setShowLogoutConfirmation(true)}
          className="inline-flex items-center gap-2 rounded-lg border border-slate-300 px-3 py-2 text-sm font-medium text-slate-600 hover:border-red-200 hover:bg-red-50 hover:text-red-600 transition-colors"
        >
          <LogOut className="h-4 w-4" />
          Logout
        </button>
      </header>

      {showLogoutConfirmation && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/40 p-4 backdrop-blur-sm">
          <div
            role="dialog"
            aria-modal="true"
            aria-labelledby="logout-confirmation-title"
            className="w-full max-w-sm rounded-xl bg-white p-6 shadow-xl"
          >
            <h2 id="logout-confirmation-title" className="text-lg font-semibold text-slate-800">
              Log out?
            </h2>
            <p className="mt-2 text-sm text-slate-500">
              Are you sure you want to log out?
            </p>
            <div className="mt-6 flex justify-end gap-3">
              <button
                type="button"
                onClick={() => setShowLogoutConfirmation(false)}
                className="rounded-lg border border-slate-300 px-4 py-2 text-sm font-medium text-slate-600 transition-colors hover:bg-slate-50"
              >
                Cancel
              </button>
              <button
                type="button"
                onClick={clearAuth}
                className="rounded-lg bg-red-600 px-4 py-2 text-sm font-medium text-white transition-colors hover:bg-red-700"
              >
                Log out
              </button>
            </div>
          </div>
        </div>
      )}
    </>
  );
}
