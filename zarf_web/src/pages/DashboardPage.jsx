import { useState } from 'react';
import { useQueries } from '@tanstack/react-query';
import axiosClient from '../api/axiosClient';
import StatCard from '../components/shared/StatCard';
import SpendByCategoryChart from '../components/charts/SpendByCategoryChart';
import VATSummaryCard from '../components/charts/VATSummaryCard';
import MonthlySpendChart from '../components/charts/MonthlySpendChart';

const getMonthYear = (date) => ({ month: date.getMonth() + 1, year: date.getFullYear() });

const monthNames = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

export default function DashboardPage() {
  const [selected, setSelected] = useState(new Date());
  const { month, year } = getMonthYear(selected);
  const rollingMonths = Array.from({ length: 6 }).map((_, idx) => {
    const d = new Date();
    d.setMonth(d.getMonth() - (5 - idx));
    return { month: d.getMonth() + 1, year: d.getFullYear(), label: d.toLocaleString('en', { month: 'short' }) };
  });

  const [summaryQuery, categoryQuery, vatQuery, ...monthlyQueries] = useQueries({
    queries: [
      { queryKey: ['analytics-summary', month, year], queryFn: async () => (await axiosClient.get('/analytics/summary', { params: { month, year } })).data.data },
      { queryKey: ['analytics-category', month, year], queryFn: async () => (await axiosClient.get('/analytics/by-category', { params: { month, year } })).data.data },
      { queryKey: ['analytics-vat', month, year], queryFn: async () => (await axiosClient.get('/analytics/vat-report', { params: { month, year } })).data.data },
      ...rollingMonths.map((item) => ({
        queryKey: ['analytics-summary', item.month, item.year, 'rolling'],
        queryFn: async () =>
          (
            await axiosClient.get('/analytics/summary', {
              params: { month: item.month, year: item.year }
            })
          ).data.data
      }))
    ]
  });

  const last6Months = rollingMonths.map((item, idx) => ({
    label: item.label,
    total: monthlyQueries[idx]?.data?.approvedTotal ?? 0
  }));

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex justify-between items-center">
        <div className="flex items-center gap-3">
          <h2 className="text-2xl font-bold text-slate-800">Dashboard</h2>
          <span className="inline-flex items-center text-xs font-semibold text-teal-700 bg-teal-50 px-2.5 py-1 rounded-full">
            {monthNames[month - 1]} {year}
          </span>
        </div>
        <input
          type="month"
          value={`${year}-${String(month).padStart(2, '0')}`}
          onChange={(e) => setSelected(new Date(`${e.target.value}-01`))}
          className="border border-slate-300 rounded-lg px-3 py-2 text-sm text-slate-600"
        />
      </div>

      {/* Stat cards */}
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
        <StatCard label="Total Spend" value={summaryQuery.data?.totalSpend ?? 0} />
        <StatCard label="Pending Approvals" value={summaryQuery.data?.pendingCount ?? 0} />
        <StatCard label="Approved Total" value={summaryQuery.data?.approvedTotal ?? 0} />
        <StatCard label="Total VAT" value={summaryQuery.data?.totalVAT ?? 0} />
      </div>

      {/* Charts */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-4">
        <MonthlySpendChart data={last6Months} />
        <SpendByCategoryChart data={categoryQuery.data || []} />
      </div>

      {/* VAT */}
      <VATSummaryCard report={vatQuery.data} />
    </div>
  );
}
