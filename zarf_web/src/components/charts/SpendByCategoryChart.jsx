import { Cell, Pie, PieChart, ResponsiveContainer, Tooltip } from 'recharts';

const COLORS = ['#0f766e', '#0369a1', '#a16207', '#7c3aed', '#dc2626', '#059669'];

export default function SpendByCategoryChart({ data }) {
  return (
    <div className="bg-white rounded border p-4 h-80">
      <h3 className="font-medium mb-2">Spend by Category</h3>
      <ResponsiveContainer width="100%" height="100%">
        <PieChart>
          <Pie data={data} dataKey="total" nameKey="category" outerRadius={100}>
            {data.map((entry, index) => (
              <Cell key={`${entry.category}-${index}`} fill={COLORS[index % COLORS.length]} />
            ))}
          </Pie>
          <Tooltip />
        </PieChart>
      </ResponsiveContainer>
    </div>
  );
}
