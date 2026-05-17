const colorMap = {
  pending: 'bg-amber-50 text-amber-700 border border-amber-200',
  approved: 'bg-emerald-50 text-emerald-700 border border-emerald-200',
  rejected: 'bg-rose-50 text-rose-700 border border-rose-200'
};

export default function ExpenseStatusBadge({ status }) {
  return (
    <span className={`inline-block px-2.5 py-1 rounded-full text-xs font-semibold capitalize ${colorMap[status] || 'bg-slate-100 text-slate-700 border border-slate-200'}`}>
      {status}
    </span>
  );
}
