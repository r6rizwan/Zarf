export default function FilterBar({ filters, setFilters }) {
  return (
    <div className="grid grid-cols-1 md:grid-cols-5 gap-3 bg-white p-4 rounded border">
      <select
        className="border rounded px-2 py-1"
        value={filters.status}
        onChange={(e) => setFilters((f) => ({ ...f, status: e.target.value }))}
      >
        <option value="">All Status</option>
        <option value="pending">Pending</option>
        <option value="approved">Approved</option>
        <option value="rejected">Rejected</option>
      </select>
      <input
        className="border rounded px-2 py-1"
        placeholder="Employee ID"
        value={filters.userId}
        onChange={(e) => setFilters((f) => ({ ...f, userId: e.target.value }))}
      />
      <input
        className="border rounded px-2 py-1"
        placeholder="Category"
        value={filters.category}
        onChange={(e) => setFilters((f) => ({ ...f, category: e.target.value }))}
      />
      <input
        type="date"
        className="border rounded px-2 py-1"
        value={filters.from}
        onChange={(e) => setFilters((f) => ({ ...f, from: e.target.value }))}
      />
      <input
        type="date"
        className="border rounded px-2 py-1"
        value={filters.to}
        onChange={(e) => setFilters((f) => ({ ...f, to: e.target.value }))}
      />
    </div>
  );
}
