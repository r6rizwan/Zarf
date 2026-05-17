import { Cell, Pie, PieChart, ResponsiveContainer, Tooltip, Legend } from 'recharts';

const COLORS = ['#0d9488', '#0369a1', '#d97706', '#7c3aed', '#dc2626', '#059669'];

export default function SpendByCategoryChart({ data }) {
  return (
    <div className="bg-white rounded-xl shadow-sm p-6 h-80">
      <h3 className="text-sm font-semibold text-slate-700 uppercase tracking-wide mb-4">Spend by Category</h3>
      <ResponsiveContainer width="100%" height="85%">
        <PieChart>
          <Pie data={data} dataKey="total" nameKey="category" outerRadius={90} innerRadius={40} paddingAngle={2}>
            {data.map((entry, index) => (
              <Cell key={`${entry.category}-${index}`} fill={COLORS[index % COLORS.length]} />
            ))}
          </Pie>
          <Tooltip
            contentStyle={{ borderRadius: '8px', border: '1px solid #e2e8f0', boxShadow: '0 4px 6px -1px rgba(0,0,0,0.1)' }}
          />
          <Legend iconType="circle" wrapperStyle={{ fontSize: '12px' }} />
        </PieChart>
      </ResponsiveContainer>
    </div>
  );
}
