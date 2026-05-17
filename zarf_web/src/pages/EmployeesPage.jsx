import { useState } from 'react';
import { useQuery } from '@tanstack/react-query';
import axiosClient from '../api/axiosClient';
import { formatAmount } from '../utils/formatCurrency';

export default function EmployeesPage() {
  const [selected, setSelected] = useState(new Date());
  const month = selected.getMonth() + 1;
  const year = selected.getFullYear();

  const query = useQuery({
    queryKey: ['analytics-by-employee', month, year],
    queryFn: async () => (await axiosClient.get('/analytics/by-employee', { params: { month, year } })).data.data
  });

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
              <th className="px-5 py-3 text-xs font-semibold text-slate-500 uppercase tracking-wide">Name</th>
              <th className="px-5 py-3 text-xs font-semibold text-slate-500 uppercase tracking-wide">Email</th>
              <th className="px-5 py-3 text-xs font-semibold text-slate-500 uppercase tracking-wide">Role</th>
              <th className="px-5 py-3 text-xs font-semibold text-slate-500 uppercase tracking-wide">Total Spend</th>
            </tr>
          </thead>
          <tbody className="divide-y divide-slate-100">
            {(query.data || []).map((item) => (
              <tr key={String(item.userId)} className="hover:bg-slate-50/50 transition-colors">
                <td className="px-5 py-3.5 font-medium text-slate-800">{item.name}</td>
                <td className="px-5 py-3.5 text-slate-600">{item.email || '-'}</td>
                <td className="px-5 py-3.5">
                  <span className="inline-block text-xs font-medium capitalize text-slate-600 bg-slate-100 px-2 py-0.5 rounded">
                    {item.role || '-'}
                  </span>
                </td>
                <td className="px-5 py-3.5 font-semibold text-slate-800">{formatAmount(item.total, 'AED')}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}
