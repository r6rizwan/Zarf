import { useState } from 'react';
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';
import axiosClient from '../api/axiosClient';
import FilterBar from '../components/shared/FilterBar';
import ExpenseTable from '../components/expenses/ExpenseTable';
import ApproveRejectModal from '../components/expenses/ApproveRejectModal';
import ExportCSVButton from '../components/expenses/ExportCSVButton';
import { ChevronLeft, ChevronRight } from 'lucide-react';

export default function ExpensesPage() {
  const [page, setPage] = useState(1);
  const [filters, setFilters] = useState({ status: '', userId: '', category: '', from: '', to: '' });
  const [modal, setModal] = useState({ open: false, expense: null, action: null });
  const qc = useQueryClient();

  const expensesQuery = useQuery({
    queryKey: ['expenses', page, filters],
    queryFn: async () => {
      const res = await axiosClient.get('/expenses', { params: { page, limit: 20, ...filters } });
      return res.data;
    }
  });

  const mutation = useMutation({
    mutationFn: async ({ id, status, reviewNote }) => axiosClient.patch(`/expenses/${id}/status`, { status, reviewNote }),
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ['expenses'] });
      setModal({ open: false, expense: null, action: null });
    }
  });

  const data = expensesQuery.data?.data || [];
  const totalPages = expensesQuery.data?.totalPages || 1;

  return (
    <div className="space-y-5">
      <div className="flex justify-between items-center">
        <h2 className="text-2xl font-bold text-slate-800">Expenses</h2>
        <ExportCSVButton rows={data.map((e) => ({
          employee: e.userId?.name,
          merchant: e.notes,
          amount: e.amountBase ?? e.amount,
          vatAmount: e.vatAmount,
          category: e.category,
          date: e.date,
          status: e.status
        }))} />
      </div>

      <FilterBar filters={filters} setFilters={setFilters} />
      <ExpenseTable items={data} onAction={(expense, action) => setModal({ open: true, expense, action })} />

      {/* Pagination */}
      <div className="flex items-center justify-between">
        <p className="text-sm text-slate-500">Page {page} of {totalPages}</p>
        <div className="flex gap-2">
          <button
            className="inline-flex items-center gap-1 px-3 py-2 text-sm font-medium border border-slate-300 rounded-lg text-slate-600 hover:bg-slate-50 disabled:opacity-40 disabled:cursor-not-allowed transition-colors"
            disabled={page <= 1}
            onClick={() => setPage((p) => p - 1)}
          >
            <ChevronLeft className="w-4 h-4" /> Previous
          </button>
          <button
            className="inline-flex items-center gap-1 px-3 py-2 text-sm font-medium border border-slate-300 rounded-lg text-slate-600 hover:bg-slate-50 disabled:opacity-40 disabled:cursor-not-allowed transition-colors"
            disabled={page >= totalPages}
            onClick={() => setPage((p) => p + 1)}
          >
            Next <ChevronRight className="w-4 h-4" />
          </button>
        </div>
      </div>

      <ApproveRejectModal
        open={modal.open}
        action={modal.action}
        loading={mutation.isPending}
        onClose={() => setModal({ open: false, expense: null, action: null })}
        onConfirm={(note) => mutation.mutate({ id: modal.expense._id || modal.expense.id, status: modal.action, reviewNote: note })}
      />
    </div>
  );
}
