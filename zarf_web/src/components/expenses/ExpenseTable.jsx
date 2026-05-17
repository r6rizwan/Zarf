import ExpenseStatusBadge from './ExpenseStatusBadge';
import { formatAmount } from '../../utils/formatCurrency';

export default function ExpenseTable({ items, onAction }) {
  return (
    <div className="bg-white border rounded overflow-x-auto">
      <table className="w-full text-sm">
        <thead>
          <tr className="bg-slate-100 text-left">
            <th className="p-2">Employee</th>
            <th className="p-2">Merchant</th>
            <th className="p-2">Amount</th>
            <th className="p-2">VAT</th>
            <th className="p-2">Category</th>
            <th className="p-2">Date</th>
            <th className="p-2">Status</th>
            <th className="p-2">Receipt</th>
            <th className="p-2">Actions</th>
          </tr>
        </thead>
        <tbody>
          {items.map((expense) => (
            <tr key={expense._id || expense.id} className="border-t">
              <td className="p-2">{expense.userId?.name || expense.userName || '-'}</td>
              <td className="p-2">{expense.notes || '-'}</td>
              <td className="p-2">{formatAmount(expense.amountBase ?? expense.amount, 'AED')}</td>
              <td className="p-2">{expense.vatAmount ?? 0}</td>
              <td className="p-2">{expense.category}</td>
              <td className="p-2">{String(expense.date).split('T')[0]}</td>
              <td className="p-2"><ExpenseStatusBadge status={expense.status} /></td>
              <td className="p-2">{expense.receiptUrl ? <a className="text-blue-600" href={expense.receiptUrl} target="_blank">View</a> : '-'}</td>
              <td className="p-2 flex gap-2">
                <button disabled={expense.status !== 'pending'} className="px-2 py-1 border rounded" onClick={() => onAction(expense, 'approved')}>Approve</button>
                <button disabled={expense.status !== 'pending'} className="px-2 py-1 border rounded" onClick={() => onAction(expense, 'rejected')}>Reject</button>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}
