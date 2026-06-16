import { useState, useEffect } from 'react';
import { useLocation, useNavigate } from 'react-router-dom';
import axiosClient from '../api/axiosClient';
import { useAuthStore } from '../store/authStore';
import { Wallet, Loader2, WifiOff } from 'lucide-react';

export default function LoginPage() {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);
  const [serverStatus, setServerStatus] = useState('checking'); // 'checking', 'waking', 'connected', 'error'
  const navigate = useNavigate();
  const location = useLocation();
  const setAuth = useAuthStore((s) => s.setAuth);

  useEffect(() => {
    let active = true;
    const wakeTimer = setTimeout(() => {
      if (active) {
        setServerStatus((prev) => (prev === 'checking' ? 'waking' : prev));
      }
    }, 1500);

    axiosClient
      .get('/health')
      .then(() => {
        if (active) {
          clearTimeout(wakeTimer);
          setServerStatus('connected');
        }
      })
      .catch((err) => {
        console.error('Health check failed', err);
        if (active) {
          clearTimeout(wakeTimer);
          setServerStatus('error');
        }
      });

    return () => {
      active = false;
      clearTimeout(wakeTimer);
    };
  }, []);

  const submit = async (e) => {
    e.preventDefault();
    setError('');
    setLoading(true);
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
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="min-h-screen flex">
      {/* Left branding panel — hidden on mobile */}
      <div className="hidden lg:flex lg:w-1/2 items-center justify-center" style={{ backgroundColor: '#0f172a' }}>
        <div className="text-center px-12">
          <div className="flex items-center justify-center gap-3 mb-6">
            <div className="w-14 h-14 rounded-xl bg-teal-600 flex items-center justify-center">
              <Wallet className="w-7 h-7 text-white" />
            </div>
            <h1 className="text-5xl font-bold text-white tracking-tight">Zarf</h1>
          </div>
          <p className="text-slate-400 text-lg">Smart expense management for modern teams</p>
        </div>
      </div>

      {/* Right login panel */}
      <div className="flex-1 flex items-center justify-center bg-white px-6">
        <div className="w-full max-w-sm">
          {/* Mobile-only logo */}
          <div className="flex items-center gap-2 mb-8 lg:hidden">
            <div className="w-10 h-10 rounded-lg bg-teal-600 flex items-center justify-center">
              <Wallet className="w-5 h-5 text-white" />
            </div>
            <span className="text-2xl font-bold text-slate-800">Zarf</span>
          </div>

          <h2 className="text-2xl font-bold text-slate-800 mb-1">Welcome back</h2>
          <p className="text-slate-500 text-sm mb-8">Sign in to your dashboard</p>

          {location.state?.message && (
            <div className="bg-amber-50 border border-amber-200 rounded-lg px-4 py-3 mb-4">
              <p className="text-amber-700 text-sm">{location.state.message}</p>
            </div>
          )}

          {serverStatus === 'waking' && (
            <div className="bg-sky-50 border border-sky-200 rounded-lg px-4 py-3 mb-4 flex items-start gap-3">
              <Loader2 className="w-5 h-5 text-sky-600 animate-spin shrink-0 mt-0.5" />
              <div>
                <p className="text-sky-800 text-sm font-medium">Waking up server...</p>
                <p className="text-sky-600 text-xs mt-0.5 leading-relaxed">
                  The API is hosted on Render's free tier and is currently sleeping. Waking it up may take up to 60 seconds. Thank you for your patience!
                </p>
              </div>
            </div>
          )}

          <form onSubmit={submit} className="space-y-4">
            <div>
              <label className="block text-sm font-medium text-slate-700 mb-1.5">Email</label>
              <input
                className="w-full border border-slate-300 rounded-md px-3.5 py-2.5 text-sm placeholder-slate-400 transition-colors"
                placeholder="you@company.com"
                type="email"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
              />
            </div>
            <div>
              <label className="block text-sm font-medium text-slate-700 mb-1.5">Password</label>
              <input
                className="w-full border border-slate-300 rounded-md px-3.5 py-2.5 text-sm placeholder-slate-400 transition-colors"
                type="password"
                placeholder="••••••••"
                value={password}
                onChange={(e) => setPassword(e.target.value)}
              />
            </div>

            {error && (
              <div className="bg-red-50 border border-red-200 rounded-lg px-4 py-3">
                <p className="text-red-600 text-sm">{error}</p>
              </div>
            )}

            <button
              type="submit"
              disabled={loading}
              className="w-full bg-teal-600 hover:bg-teal-700 text-white font-medium rounded-md py-2.5 text-sm transition-colors disabled:opacity-60 disabled:cursor-not-allowed flex items-center justify-center gap-2"
              style={{ height: '44px' }}
            >
              {loading && <span className="btn-spinner" />}
              {loading ? 'Signing in…' : 'Sign in'}
            </button>
          </form>

          <p className="text-center text-xs text-slate-400 mt-12">
            Powered by Groq AI
          </p>
        </div>
      </div>
    </div>
  );
}
