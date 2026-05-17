import { formatAmount } from '../../utils/formatCurrency';

export default function VATSummaryCard({ report }) {
  return (
    <div className="bg-white rounded border p-4">
      <h3 className="font-medium">VAT Summary</h3>
      <p className="mt-2 text-sm">VAT Rate: {report?.vatRate ?? 0}%</p>
      <p className="text-lg font-semibold">
        {formatAmount(report?.totalVATClaimable ?? 0, report?.currency ?? 'AED')}
      </p>
    </div>
  );
}
