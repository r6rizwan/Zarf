import { useState } from 'react';
import { useLocation, useNavigate } from 'react-router-dom';
import axiosClient from '../api/axiosClient';
import { useAuthStore } from '../store/authStore';

export default function LoginPage() {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState('');
  const navigate = useNavigate();
  const location = useLocation();
  const setAuth = useAuthStore((s) => s.setAuth);

  const submit = async (e) => {
    e.preventDefault();
    setError('');
    try {
      const res = await axiosClient.post('/auth/login', { email, password });
      const { user, accessToken, refreshToken } = res.data;

      if (user.role === 'employee') {
        setError('Please use the Zarf mobile app');
        return;
      }

      setAuth(user, accessToken, refreshToken);
      navigate('/dashboard');
    } catch (err) {
      setError(err?.response?.data?.message || 'Login failed');
    }
  };

  return (
    <div className="min-h-screen flex items-center justify-center p-4">
      <form className="bg-white border rounded p-6 w-full max-w-sm" onSubmit={submit}>
        <h1 className="text-xl font-semibold">Zarf Login</h1>
        {location.state?.message && <p className="text-amber-700 text-sm mt-2">{location.state.message}</p>}
        <input className="w-full border rounded p-2 mt-4" placeholder="Email" value={email} onChange={(e) => setEmail(e.target.value)} />
        <input className="w-full border rounded p-2 mt-3" type="password" placeholder="Password" value={password} onChange={(e) => setPassword(e.target.value)} />
        {error && <p className="text-red-600 text-sm mt-3">{error}</p>}
        <button className="w-full mt-4 bg-slate-900 text-white rounded py-2">Login</button>
      </form>
    </div>
  );
}
