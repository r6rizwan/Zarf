import { formatAmount } from '../../utils/formatCurrency';
import ExpenseStatusBadge from './ExpenseStatusBadge';

export default function ExpenseDetailModal({ expense, onClose }) {
  if (!expense) return null;

  return (
    <div className="fixed inset-0 bg-black/40 backdrop-blur-sm flex items-center justify-center p-4 z-50">
      <div className="bg-white rounded-xl shadow-xl p-6 w-full max-w-2xl animate-in">
        <div className="flex items-start justify-between gap-4">
          <div>
            <h3 className="text-xl font-semibold text-slate-900">Expense details</h3>
            <p className="text-sm text-slate-500 mt-1">Review the full expense record before approving or rejecting.</p>
          </div>
          <button
            type="button"
            className="text-slate-500 hover:text-slate-900"
            onClick={onClose}
          >
            Close
          </button>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 gap-4 mt-6">
          <div className="space-y-3">
            <div>
              <p className="text-xs uppercase tracking-wide text-slate-500">Employee</p>
              <p className="text-sm text-slate-900 font-medium">{expense.userId?.name || expense.userName || '-'}</p>
            </div>
            <div>
              <p className="text-xs uppercase tracking-wide text-slate-500">Merchant</p>
              <p className="text-sm text-slate-900 font-medium">{expense.notes || '-'}</p>
            </div>
            <div>
              <p className="text-xs uppercase tracking-wide text-slate-500">Category</p>
              <p className="text-sm text-slate-900 font-medium">{expense.category || '-'}</p>
            </div>
            <div>
              <p className="text-xs uppercase tracking-wide text-slate-500">Payment method</p>
              <p className="text-sm text-slate-900 font-medium">{expense.paymentMethod || '-'}</p>
            </div>
          </div>

          <div className="space-y-3">
            <div>
              <p className="text-xs uppercase tracking-wide text-slate-500">Date</p>
              <p className="text-sm text-slate-900 font-medium">{String(expense.date).split('T')[0]}</p>
            </div>
            <div>
              <p className="text-xs uppercase tracking-wide text-slate-500">Amount</p>
              <p className="text-sm text-slate-900 font-medium">{formatAmount(expense.amountBase ?? expense.amount, 'AED')}</p>
            </div>
            <div>
              <p className="text-xs uppercase tracking-wide text-slate-500">VAT</p>
              <p className="text-sm text-slate-900 font-medium">{formatAmount(expense.vatAmount ?? 0, 'AED')}</p>
            </div>
            <div>
              <p className="text-xs uppercase tracking-wide text-slate-500">Status</p>
              <ExpenseStatusBadge status={expense.status} />
            </div>
          </div>
        </div>

        <div className="mt-6 space-y-3">
          <div>
            <p className="text-xs uppercase tracking-wide text-slate-500">Notes</p>
            <p className="text-sm text-slate-900">{expense.notes || 'No notes provided.'}</p>
          </div>
          <div>
            <p className="text-xs uppercase tracking-wide text-slate-500">Receipt</p>
            {expense.receiptUrl ? (
              <a
                className="text-teal-600 hover:text-teal-700 font-medium text-sm"
                href={expense.receiptUrl}
                target="_blank"
                rel="noreferrer"
              >
                View receipt
              </a>
            ) : (
              <p className="text-sm text-slate-500">No receipt attached.</p>
            )}
          </div>
        </div>
      </div>
    </div>
  );
}
