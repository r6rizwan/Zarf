import { useState } from 'react';
import { useQuery } from '@tanstack/react-query';
import axiosClient from '../api/axiosClient';

export default function EmployeesPage() {
  const [selected, setSelected] = useState(new Date());
  const month = selected.getMonth() + 1;
  const year = selected.getFullYear();

  const query = useQuery({
    queryKey: ['analytics-by-employee', month, year],
    queryFn: async () => (await axiosClient.get('/analytics/by-employee', { params: { month, year } })).data.data
  });

  return (
    <div className="space-y-4">
      <div className="flex justify-between">
        <h2 className="text-xl font-semibold">Employees</h2>
        <input
          type="month"
          value={`${year}-${String(month).padStart(2, '0')}`}
          onChange={(e) => setSelected(new Date(`${e.target.value}-01`))}
          className="border rounded px-2 py-1"
        />
      </div>

      <div className="bg-white border rounded overflow-x-auto">
        <table className="w-full text-sm">
          <thead>
            <tr className="bg-slate-100 text-left">
              <th className="p-2">Name</th>
              <th className="p-2">Email</th>
              <th className="p-2">Role</th>
              <th className="p-2">Total Spend</th>
            </tr>
          </thead>
          <tbody>
            {(query.data || []).map((item) => (
              <tr key={String(item.userId)} className="border-t">
                <td className="p-2">{item.name}</td>
                <td className="p-2">{item.email || '-'}</td>
                <td className="p-2">{item.role || '-'}</td>
                <td className="p-2">{item.total}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}
