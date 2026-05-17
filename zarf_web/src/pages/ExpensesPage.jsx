import { useState } from 'react';
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';
import axiosClient from '../api/axiosClient';
import FilterBar from '../components/shared/FilterBar';
import ExpenseTable from '../components/expenses/ExpenseTable';
import ApproveRejectModal from '../components/expenses/ApproveRejectModal';
import ExportCSVButton from '../components/expenses/ExportCSVButton';

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
    <div className="space-y-4">
      <div className="flex justify-between">
        <h2 className="text-xl font-semibold">Expenses</h2>
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

      <div className="flex gap-3 items-center">
        <button className="px-3 py-1 border rounded" disabled={page <= 1} onClick={() => setPage((p) => p - 1)}>Previous</button>
        <span>Page {page} / {totalPages}</span>
        <button className="px-3 py-1 border rounded" disabled={page >= totalPages} onClick={() => setPage((p) => p + 1)}>Next</button>
      </div>

      <ApproveRejectModal
        open={modal.open}
        action={modal.action}
        onClose={() => setModal({ open: false, expense: null, action: null })}
        onConfirm={(note) => mutation.mutate({ id: modal.expense._id || modal.expense.id, status: modal.action, reviewNote: note })}
      />
    </div>
  );
}
