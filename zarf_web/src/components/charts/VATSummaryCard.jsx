import { formatAmount } from '../../utils/formatCurrency';
import { Receipt } from 'lucide-react';

export default function VATSummaryCard({ report }) {
  return (
    <div className="bg-white rounded-xl shadow-sm p-6 border-l-4 border-teal-500">
      <div className="flex items-center justify-between mb-4">
        <h3 className="text-sm font-semibold text-slate-700 uppercase tracking-wide">VAT Summary</h3>
        <span className="inline-flex items-center gap-1 text-xs font-semibold text-teal-700 bg-teal-50 px-2.5 py-1 rounded-full">
          {report?.vatRate ?? 0}% VAT
        </span>
      </div>
      <div className="flex items-center gap-4">
        <div className="w-12 h-12 rounded-lg bg-teal-50 flex items-center justify-center">
          <Receipt className="w-6 h-6 text-teal-600" />
        </div>
        <div>
          <p className="text-xs text-slate-500 mb-0.5">Total Claimable VAT</p>
          <p className="text-2xl font-bold text-slate-800">
            {formatAmount(report?.totalVATClaimable ?? 0, report?.currency ?? 'AED')}
          </p>
        </div>
      </div>
    </div>
  );
}
