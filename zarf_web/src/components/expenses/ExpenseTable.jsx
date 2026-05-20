import ExpenseStatusBadge from './ExpenseStatusBadge';
import { formatAmount } from '../../utils/formatCurrency';

export default function ExpenseTable({ items, loading, sortKey, sortOrder, onSort, onAction, onView }) {
  const renderHeader = (label, key) => (
    <button
      type="button"
      onClick={() => onSort(key)}
      className="inline-flex items-center gap-1 text-left"
    >
      {label}
      <span>{sortKey === key ? (sortOrder === 'asc' ? '▲' : '▼') : '↕'}</span>
    </button>
  );

  return (
    <div className="bg-white rounded-xl shadow-sm overflow-hidden">
      <table className="w-full text-sm">
        <thead>
          <tr className="bg-slate-50 text-left border-b border-slate-200">
            <th className="px-5 py-3 text-xs font-semibold text-slate-500 uppercase tracking-wide">{renderHeader('Employee', 'employee')}</th>
            <th className="px-5 py-3 text-xs font-semibold text-slate-500 uppercase tracking-wide">{renderHeader('Merchant', 'merchant')}</th>
            <th className="px-5 py-3 text-xs font-semibold text-slate-500 uppercase tracking-wide">{renderHeader('Amount', 'amount')}</th>
            <th className="px-5 py-3 text-xs font-semibold text-slate-500 uppercase tracking-wide">{renderHeader('VAT', 'vat')}</th>
            <th className="px-5 py-3 text-xs font-semibold text-slate-500 uppercase tracking-wide">{renderHeader('Category', 'category')}</th>
            <th className="px-5 py-3 text-xs font-semibold text-slate-500 uppercase tracking-wide">{renderHeader('Date', 'date')}</th>
            <th className="px-5 py-3 text-xs font-semibold text-slate-500 uppercase tracking-wide">{renderHeader('Status', 'status')}</th>
            <th className="px-5 py-3 text-xs font-semibold text-slate-500 uppercase tracking-wide">Receipt</th>
            <th className="px-5 py-3 text-xs font-semibold text-slate-500 uppercase tracking-wide">Actions</th>
          </tr>
        </thead>
        <tbody className="divide-y divide-slate-100">
          {loading ? (
            <tr>
              <td colSpan={9} className="px-5 py-10 text-center text-sm text-slate-500">Loading expenses…</td>
            </tr>
          ) : items.length === 0 ? (
            <tr>
              <td colSpan={9} className="px-5 py-10 text-center text-sm text-slate-500">No expenses found for these filters.</td>
            </tr>
          ) : (
            items.map((expense) => (
              <tr key={expense._id || expense.id} className="hover:bg-slate-50/50 transition-colors">
                <td className="px-5 py-3.5 font-medium text-slate-800">{expense.userId?.name || expense.userName || '-'}</td>
                <td className="px-5 py-3.5 text-slate-600">{expense.notes || '-'}</td>
                <td className="px-5 py-3.5 font-semibold text-slate-800">{formatAmount(expense.amountBase ?? expense.amount, 'AED')}</td>
                <td className="px-5 py-3.5 text-slate-600">{formatAmount(expense.vatAmount ?? 0, 'AED')}</td>
                <td className="px-5 py-3.5">
                  <span className="inline-block text-xs font-medium text-slate-600 bg-slate-100 px-2 py-0.5 rounded capitalize">{expense.category}</span>
                </td>
                <td className="px-5 py-3.5 text-slate-600">{String(expense.date).split('T')[0]}</td>
                <td className="px-5 py-3.5"><ExpenseStatusBadge status={expense.status} /></td>
                <td className="px-5 py-3.5">
                  {expense.receiptUrl ? (
                    <a className="text-teal-600 hover:text-teal-700 font-medium text-xs" href={expense.receiptUrl} target="_blank">View</a>
                  ) : (
                    <span className="text-slate-400">-</span>
                  )}
                </td>
                <td className="px-5 py-3.5">
                  <div className="flex flex-wrap gap-2">
                    <button
                      type="button"
                      className="px-2.5 py-1.5 text-xs font-medium rounded-md border border-slate-300 text-slate-700 hover:bg-slate-100 transition-colors"
                      onClick={() => onView(expense)}
                    >
                      Details
                    </button>
                    <button
                      type="button"
                      disabled={expense.status !== 'pending'}
                      className="px-2.5 py-1.5 text-xs font-medium rounded-md border border-emerald-300 text-emerald-700 hover:bg-emerald-50 disabled:opacity-40 disabled:cursor-not-allowed transition-colors"
                      onClick={() => onAction(expense, 'approved')}
                    >
                      Approve
                    </button>
                    <button
                      type="button"
                      disabled={expense.status !== 'pending'}
                      className="px-2.5 py-1.5 text-xs font-medium rounded-md border border-rose-300 text-rose-700 hover:bg-rose-50 disabled:opacity-40 disabled:cursor-not-allowed transition-colors"
                      onClick={() => onAction(expense, 'rejected')}
                    >
                      Reject
                    </button>
                  </div>
                </td>
              </tr>
            ))
          )}
        </tbody>
      </table>
    </div>
  );
}
