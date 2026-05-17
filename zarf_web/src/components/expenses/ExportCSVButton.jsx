import { exportRowsToCSV } from '../../utils/exportCSV';
import { Download } from 'lucide-react';

export default function ExportCSVButton({ rows }) {
  return (
    <button
      className="inline-flex items-center gap-2 px-4 py-2 text-sm font-medium border border-slate-300 rounded-lg text-slate-600 hover:bg-slate-50 transition-colors"
      onClick={() => exportRowsToCSV(rows, 'zarf-expenses.csv')}
    >
      <Download className="w-4 h-4" />
      Export CSV
    </button>
  );
}
