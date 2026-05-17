import { Navigate } from 'react-router-dom';
import { useAuthStore } from '../../store/authStore';

export default function ProtectedRoute({ children, allowedRoles }) {
  const { isAuthenticated, user } = useAuthStore();

  if (!isAuthenticated) return <Navigate to="/login" replace />;

  if (user?.role === 'employee') {
    return <Navigate to="/login" replace state={{ message: 'Please use the Zarf mobile app' }} />;
  }

  if (!allowedRoles.includes(user?.role)) return <Navigate to="/dashboard" replace />;

  return children;
}
