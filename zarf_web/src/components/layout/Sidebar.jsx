import { Link, useLocation } from 'react-router-dom';
import { useAuthStore } from '../../store/authStore';
import { LayoutDashboard, Receipt, Users, Settings, Wallet } from 'lucide-react';

const navItems = [
  { to: '/dashboard', label: 'Dashboard', icon: LayoutDashboard, roles: ['manager', 'admin'] },
  { to: '/expenses', label: 'Expenses', icon: Receipt, roles: ['manager', 'admin'] },
  { to: '/employees', label: 'Employees', icon: Users, roles: ['admin'] },
  { to: '/settings', label: 'Settings', icon: Settings, roles: ['admin'] },
];

export default function Sidebar() {
  const { user } = useAuthStore();
  const location = useLocation();

  return (
    <aside className="w-64 min-h-screen flex flex-col" style={{ backgroundColor: '#0f172a' }}>
      {/* Logo */}
      <div className="px-5 py-6 flex items-center gap-2.5">
        <div className="w-9 h-9 rounded-lg bg-teal-600 flex items-center justify-center">
          <Wallet className="w-4.5 h-4.5 text-white" />
        </div>
        <span className="text-xl font-bold text-white tracking-tight">Zarf</span>
      </div>

      {/* Navigation */}
      <nav className="flex-1 px-3 mt-2 flex flex-col gap-1">
        {navItems
          .filter((item) => item.roles.includes(user?.role))
          .map((item) => {
            const isActive = location.pathname === item.to;
            const Icon = item.icon;

            return (
              <Link
                key={item.to}
                to={item.to}
                className={`flex items-center gap-3 px-3 py-2.5 rounded-lg text-sm font-medium transition-colors ${
                  isActive
                    ? 'bg-teal-600/20 text-teal-400 border-l-2 border-teal-500'
                    : 'text-slate-400 hover:text-white hover:bg-white/5 border-l-2 border-transparent'
                }`}
              >
                <Icon className="w-5 h-5 flex-shrink-0" />
                {item.label}
              </Link>
            );
          })}
      </nav>

      {/* User info at bottom */}
      <div className="px-5 py-4 border-t border-slate-700/50">
        <p className="text-sm text-white font-medium truncate">{user?.name}</p>
        <p className="text-xs text-slate-500 capitalize">{user?.role}</p>
      </div>
    </aside>
  );
}
