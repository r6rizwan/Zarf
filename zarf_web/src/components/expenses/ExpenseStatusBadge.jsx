const colorMap = {
  pending: 'bg-amber-100 text-amber-700',
  approved: 'bg-emerald-100 text-emerald-700',
  rejected: 'bg-rose-100 text-rose-700'
};

export default function ExpenseStatusBadge({ status }) {
  return (
    <span className={`px-2 py-1 rounded text-xs ${colorMap[status] || 'bg-slate-100 text-slate-700'}`}>
      {status}
    </span>
  );
}
