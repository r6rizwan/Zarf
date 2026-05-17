export default function FilterBar({ filters, setFilters }) {
  const inputClass = 'border border-slate-300 rounded-md px-3 py-2 text-sm text-slate-700 placeholder-slate-400 transition-colors';

  return (
    <div className="grid grid-cols-1 md:grid-cols-5 gap-3 bg-white rounded-xl shadow-sm p-4">
      <select
        className={inputClass}
        value={filters.status}
        onChange={(e) => setFilters((f) => ({ ...f, status: e.target.value }))}
      >
        <option value="">All Status</option>
        <option value="pending">Pending</option>
        <option value="approved">Approved</option>
        <option value="rejected">Rejected</option>
      </select>
      <input
        className={inputClass}
        placeholder="Employee ID"
        value={filters.userId}
        onChange={(e) => setFilters((f) => ({ ...f, userId: e.target.value }))}
      />
      <input
        className={inputClass}
        placeholder="Category"
        value={filters.category}
        onChange={(e) => setFilters((f) => ({ ...f, category: e.target.value }))}
      />
      <input
        type="date"
        className={inputClass}
        value={filters.from}
        onChange={(e) => setFilters((f) => ({ ...f, from: e.target.value }))}
      />
      <input
        type="date"
        className={inputClass}
        value={filters.to}
        onChange={(e) => setFilters((f) => ({ ...f, to: e.target.value }))}
      />
    </div>
  );
}
