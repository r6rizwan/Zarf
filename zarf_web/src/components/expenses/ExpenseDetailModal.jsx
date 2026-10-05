import { formatAmount } from '../../utils/formatCurrency';
import ExpenseStatusBadge from './ExpenseStatusBadge';

const TRN_STATUS_CONFIG = {
  format_valid: { label: 'Format Valid', cls: 'bg-teal-100 text-teal-700' },
  format_invalid: { label: 'Invalid Format', cls: 'bg-red-100 text-red-700' },
  not_provided: { label: 'Not Provided', cls: 'bg-slate-100 text-slate-500' }
};

export default function ExpenseDetailModal({ expense, baseCurrency = 'AED', onClose }) {
  if (!expense) return null;

  const trnCfg = TRN_STATUS_CONFIG[expense.trnStatus] ?? TRN_STATUS_CONFIG.not_provided;
  const hasFlags = expense.policyFlags && expense.policyFlags.length > 0;
  const curr = expense.amountBase != null ? baseCurrency : (expense.currency || baseCurrency);

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
              <p className="text-sm text-slate-900 font-medium">{formatAmount(expense.amountBase ?? expense.amount, curr)}</p>
            </div>
            <div>
              <p className="text-xs uppercase tracking-wide text-slate-500">VAT</p>
              <p className="text-sm text-slate-900 font-medium">{formatAmount(expense.vatAmount ?? 0, curr)}</p>
            </div>
            <div>
              <p className="text-xs uppercase tracking-wide text-slate-500">Status</p>
              <ExpenseStatusBadge status={expense.status} />
            </div>
          </div>
        </div>

        {/* Vendor TRN */}
        <div className="mt-4 flex items-center gap-3">
          <div className="flex-1">
            <p className="text-xs uppercase tracking-wide text-slate-500">Vendor TRN</p>
            <p className="text-sm text-slate-900 font-medium font-mono">
              {expense.vendorTrn || <span className="text-slate-400 font-sans">—</span>}
            </p>
          </div>
          <span className={`rounded-full px-2.5 py-0.5 text-xs font-medium ${trnCfg.cls}`}>
            {trnCfg.label}
          </span>
          {expense.trnStatus === 'format_valid' && (
            <a
              href="https://tax.gov.ae"
              target="_blank"
              rel="noreferrer"
              className="text-xs text-teal-600 hover:underline whitespace-nowrap"
            >
              Verify on FTA ↗
            </a>
          )}
        </div>

        {/* Policy flags */}
        {hasFlags && (
          <div className="mt-4">
            <p className="text-xs uppercase tracking-wide text-slate-500 mb-1.5">Policy Flags</p>
            <div className="flex flex-wrap gap-1.5">
              {expense.policyFlags.map((flag) => (
                <span
                  key={flag}
                  className="inline-flex items-center rounded-full bg-amber-100 px-2.5 py-0.5 text-xs font-medium text-amber-700"
                >
                  ⚠ {flag}
                </span>
              ))}
            </div>
          </div>
        )}

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

