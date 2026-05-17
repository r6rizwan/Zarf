import { Bar, BarChart, CartesianGrid, ResponsiveContainer, Tooltip, XAxis, YAxis } from 'recharts';

export default function MonthlySpendChart({ data }) {
  return (
    <div className="bg-white rounded border p-4 h-80">
      <h3 className="font-medium mb-2">Monthly Spend (Last 6 Months)</h3>
      <ResponsiveContainer width="100%" height="100%">
        <BarChart data={data}>
          <CartesianGrid strokeDasharray="3 3" />
          <XAxis dataKey="label" />
          <YAxis />
          <Tooltip />
          <Bar dataKey="total" fill="#0f766e" />
        </BarChart>
      </ResponsiveContainer>
    </div>
  );
}
