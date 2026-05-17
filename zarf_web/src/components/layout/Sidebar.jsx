import { Link } from 'react-router-dom';
import { useAuthStore } from '../../store/authStore';

export default function Sidebar() {
  const { user } = useAuthStore();

  return (
    <aside className="w-64 bg-slate-900 text-white min-h-screen p-4">
      <h1 className="text-xl font-semibold">Zarf</h1>
      <nav className="mt-6 flex flex-col gap-2">
        <Link to="/dashboard">Dashboard</Link>
        <Link to="/expenses">Expenses</Link>
        {user?.role === 'admin' && <Link to="/employees">Employees</Link>}
        {user?.role === 'admin' && <Link to="/settings">Settings</Link>}
      </nav>
    </aside>
  );
}
