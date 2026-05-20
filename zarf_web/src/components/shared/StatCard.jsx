import { TrendingUp, Clock, CheckCircle, Receipt } from 'lucide-react';
import { formatAmount } from '../../utils/formatCurrency';

const cardConfig = {
  'Total Spend': {
    icon: TrendingUp,
    iconBg: 'bg-teal-50',
    iconColor: 'text-teal-600',
    borderColor: 'border-teal-500',
    isCurrency: true,
  },
  'Pending Approvals': {
    icon: Clock,
    iconBg: 'bg-amber-50',
    iconColor: 'text-amber-600',
    borderColor: 'border-amber-500',
    isCurrency: false,
    subtitle: 'requests',
  },
  'Approved Total': {
    icon: CheckCircle,
    iconBg: 'bg-emerald-50',
    iconColor: 'text-emerald-600',
    borderColor: 'border-emerald-500',
    isCurrency: true,
  },
  'Total VAT': {
    icon: Receipt,
    iconBg: 'bg-purple-50',
    iconColor: 'text-purple-600',
    borderColor: 'border-purple-500',
    isCurrency: true,
  },
};

export default function StatCard({ label, value }) {
  const config = cardConfig[label] || cardConfig['Total Spend'];
  const Icon = config.icon;

  // Avoid passing non-numeric values into currency formatter which yields "NaN".
  const displayValueRaw = config.isCurrency
    ? (typeof value === 'number' ? formatAmount(value, 'AED') : value)
    : value;

  const isLoading = displayValueRaw === 'Loading...';

  return (
    <div className={`bg-white rounded-xl shadow-sm p-5 border-b-2 ${config.borderColor}`}>
      <div className="flex items-center justify-between mb-3">
        <p className="text-sm text-slate-500 font-medium">{label}</p>
        <div className={`w-10 h-10 rounded-lg ${config.iconBg} flex items-center justify-center`}>
          <Icon className={`w-5 h-5 ${config.iconColor}`} />
        </div>
      </div>
      <p className="text-2xl font-bold text-slate-800">
        {isLoading ? (
          <span className="inline-flex items-center">
            <svg className="animate-spin -ml-1 mr-2 h-5 w-5 text-slate-600" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
              <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4"></circle>
              <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8v4a4 4 0 00-4 4H4z"></path>
            </svg>
            Loading...
          </span>
        ) : (
          displayValueRaw
        )}
      </p>
      {config.subtitle && <p className="text-xs text-slate-400 mt-0.5">{config.subtitle}</p>}
    </div>
  );
}
