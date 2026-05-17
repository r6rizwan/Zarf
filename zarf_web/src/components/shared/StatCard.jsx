export default function StatCard({ label, value }) {
  return (
    <div className="bg-white p-4 rounded border">
      <p className="text-sm text-slate-500">{label}</p>
      <p className="text-2xl font-semibold">{value}</p>
    </div>
  );
}
