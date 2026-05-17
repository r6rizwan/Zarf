import { useAuthStore } from '../../store/authStore';
import { LogOut } from 'lucide-react';

export default function TopBar({ title }) {
  const { user, clearAuth } = useAuthStore();

  const initials = (user?.name || '')
    .split(' ')
    .map((w) => w[0])
    .join('')
    .toUpperCase()
    .slice(0, 2);

  return (
    <header className="h-16 bg-white border-b border-slate-200 flex items-center justify-between px-6">
      <h1 className="text-lg font-semibold text-slate-800">{title}</h1>

      <div className="flex items-center gap-4">
        {/* Avatar + Name + Role */}
        <div className="flex items-center gap-3">
          <div className="w-9 h-9 rounded-full bg-teal-600 flex items-center justify-center">
            <span className="text-sm font-semibold text-white">{initials}</span>
          </div>
          <div className="hidden sm:block">
            <p className="text-sm font-medium text-slate-700 leading-tight">{user?.name}</p>
            <span className="inline-block text-[10px] font-medium uppercase tracking-wider text-teal-700 bg-teal-50 px-1.5 py-0.5 rounded">
              {user?.role}
            </span>
          </div>
        </div>

        {/* Logout */}
        <button
          onClick={clearAuth}
          className="w-9 h-9 rounded-lg flex items-center justify-center text-slate-400 hover:text-red-500 hover:bg-red-50 transition-colors"
          title="Logout"
        >
          <LogOut className="w-4.5 h-4.5" />
        </button>
      </div>
    </header>
  );
}
