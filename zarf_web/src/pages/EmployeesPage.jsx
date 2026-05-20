import { useMemo, useState } from 'react';
import { useQuery } from '@tanstack/react-query';
import axiosClient from '../api/axiosClient';
import { formatAmount } from '../utils/formatCurrency';

export default function EmployeesPage() {
  const [selected, setSelected] = useState(new Date());
  const [sortKey, setSortKey] = useState('name');
  const [sortOrder, setSortOrder] = useState('asc');
  const month = selected.getMonth() + 1;
  const year = selected.getFullYear();

  const query = useQuery({
    queryKey: ['analytics-by-employee', month, year],
    queryFn: async () => (await axiosClient.get('/analytics/by-employee', { params: { month, year } })).data.data
  });

  const isLoading = query.isFetching && !query.data;
  const sortedData = useMemo(() => {
    const list = [...(query.data || [])];

    return list.sort((a, b) => {
      const direction = sortOrder === 'asc' ? 1 : -1;

      if (sortKey === 'total') {
        return (a.total - b.total) * direction;
      }

      return a.name.localeCompare(b.name) * direction;
    });
  }, [query.data, sortKey, sortOrder]);

  const handleSort = (key) => {
    if (sortKey === key) {
      setSortOrder((prev) => (prev === 'asc' ? 'desc' : 'asc'));
    } else {
      setSortKey(key);
      setSortOrder('asc');
    }
  };

  return (
    <div className="space-y-5">
      <div className="flex justify-between items-center">
        <h2 className="text-2xl font-bold text-slate-800">Employees</h2>
        <input
          type="month"
          value={`${year}-${String(month).padStart(2, '0')}`}
          onChange={(e) => setSelected(new Date(`${e.target.value}-01`))}
          className="border border-slate-300 rounded-lg px-3 py-2 text-sm text-slate-600"
        />
      </div>

      <div className="bg-white rounded-xl shadow-sm overflow-hidden">
        <table className="w-full text-sm">
          <thead>
            <tr className="bg-slate-50 text-left border-b border-slate-200">
              <th className="px-5 py-3 text-xs font-semibold text-slate-500 uppercase tracking-wide">
                <button
                  type="button"
                  onClick={() => handleSort('name')}
                  className="inline-flex items-center gap-1"
                >
                  Name
                  <span>{sortKey === 'name' ? (sortOrder === 'asc' ? '▲' : '▼') : '↕'}</span>
                </button>
              </th>
              <th className="px-5 py-3 text-xs font-semibold text-slate-500 uppercase tracking-wide">Email</th>
              <th className="px-5 py-3 text-xs font-semibold text-slate-500 uppercase tracking-wide">
                <button
                  type="button"
                  onClick={() => handleSort('total')}
                  className="inline-flex items-center gap-1"
                >
                  Total Spend
                  <span>{sortKey === 'total' ? (sortOrder === 'asc' ? '▲' : '▼') : '↕'}</span>
                </button>
              </th>
            </tr>
          </thead>
          <tbody className="divide-y divide-slate-100">
            {isLoading ? (
              <tr>
                <td colSpan={3} className="px-5 py-10 text-center text-sm text-slate-500">Loading employees…</td>
              </tr>
            ) : sortedData.length === 0 ? (
              <tr>
                <td colSpan={3} className="px-5 py-10 text-center text-sm text-slate-500">No employees found for this period.</td>
              </tr>
            ) : (
              sortedData.map((item) => (
                <tr key={String(item.userId)} className="hover:bg-slate-50/50 transition-colors">
                  <td className="px-5 py-3.5 font-medium text-slate-800">{item.name}</td>
                  <td className="px-5 py-3.5 text-slate-600">{item.email || '-'}</td>
                  <td className="px-5 py-3.5 font-semibold text-slate-800">{formatAmount(item.total, 'AED')}</td>
                </tr>
              ))
            )}
          </tbody>
        </table>
      </div>
    </div>
  );
}
