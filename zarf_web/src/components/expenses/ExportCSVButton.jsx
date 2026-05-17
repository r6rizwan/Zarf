import { exportRowsToCSV } from '../../utils/exportCSV';

export default function ExportCSVButton({ rows }) {
  return (
    <button
      className="px-3 py-2 border rounded"
      onClick={() => exportRowsToCSV(rows, 'zarf-expenses.csv')}
    >
      Export CSV
    </button>
  );
}
