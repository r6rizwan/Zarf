import { useAuthStore } from '../../store/authStore';

export default function TopBar() {
  const { user, clearAuth } = useAuthStore();

  return (
    <header className="h-16 bg-white border-b flex items-center justify-between px-6">
      <p className="text-sm text-slate-600">{user?.name}</p>
      <button className="text-sm text-red-600" onClick={clearAuth}>Logout</button>
    </header>
  );
}
