import { useEffect, useMemo, useState } from 'react';
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';
import { useSearchParams } from 'react-router-dom';
import axiosClient from '../api/axiosClient';
import FilterBar from '../components/shared/FilterBar';
import ExpenseTable from '../components/expenses/ExpenseTable';
import ExpenseDetailModal from '../components/expenses/ExpenseDetailModal';
import ApproveRejectModal from '../components/expenses/ApproveRejectModal';
import ExportCSVButton from '../components/expenses/ExportCSVButton';
import { ChevronLeft, ChevronRight } from 'lucide-react';

export default function ExpensesPage() {
  const [searchParams, setSearchParams] = useSearchParams();
  const initialPage = Number(searchParams.get('page')) || 1;
  const initialFilters = {
    status: searchParams.get('status') || '',
    userId: searchParams.get('userId') || '',
    category: searchParams.get('category') || '',
    from: searchParams.get('from') || '',
    to: searchParams.get('to') || ''
  };
  const initialSortKey = searchParams.get('sortKey') || 'date';
  const initialSortOrder = searchParams.get('sortOrder') || 'desc';

  const [page, setPage] = useState(initialPage);
  const [filters, setFilters] = useState(initialFilters);
  const [sortKey, setSortKey] = useState(initialSortKey);
  const [sortOrder, setSortOrder] = useState(initialSortOrder);
  const [modal, setModal] = useState({ open: false, expense: null, action: null });
  const [detailExpense, setDetailExpense] = useState(null);
  const qc = useQueryClient();

  useEffect(() => {
    const params = new URLSearchParams();
    if (page > 1) params.set('page', String(page));
    if (filters.status) params.set('status', filters.status);
    if (filters.userId) params.set('userId', filters.userId);
    if (filters.category) params.set('category', filters.category);
    if (filters.from) params.set('from', filters.from);
    if (filters.to) params.set('to', filters.to);
    if (sortKey !== 'date') params.set('sortKey', sortKey);
    if (sortOrder !== 'desc') params.set('sortOrder', sortOrder);
    setSearchParams(params, { replace: true });
  }, [page, filters, sortKey, sortOrder, setSearchParams]);

  const setFiltersState = (updater) => {
    setFilters((current) => {
      const next = typeof updater === 'function' ? updater(current) : updater;
      return next;
    });
    setPage(1);
  };

  const expensesQuery = useQuery({
    queryKey: ['expenses', page, filters, sortKey, sortOrder],
    queryFn: async () => {
      const res = await axiosClient.get('/expenses', {
        params: {
          page,
          limit: 20,
          sortBy: sortKey,
          sortOrder,
          ...filters
        }
      });
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
  const isLoading = expensesQuery.isFetching && data.length === 0;

  const sortedData = useMemo(() => {
    const list = [...data];
    const direction = sortOrder === 'asc' ? 1 : -1;

    return list.sort((a, b) => {
      const getValue = (item) => {
        switch (sortKey) {
          case 'employee':
            return item.userId?.name || item.userName || '';
          case 'merchant':
            return item.notes || '';
          case 'amount':
            return Number(item.amountBase ?? item.amount ?? 0);
          case 'vat':
            return Number(item.vatAmount ?? 0);
          case 'category':
            return item.category || '';
          case 'date':
            return new Date(item.date || 0).getTime();
          case 'status':
            return item.status || '';
          default:
            return item.userId?.name || item.userName || '';
        }
      };

      const valueA = getValue(a);
      const valueB = getValue(b);

      if (typeof valueA === 'number' && typeof valueB === 'number') {
        return (valueA - valueB) * direction;
      }
      return String(valueA).localeCompare(String(valueB)) * direction;
    });
  }, [data, sortKey, sortOrder]);

  const handleSort = (key) => {
    if (sortKey === key) {
      setSortOrder((prev) => (prev === 'asc' ? 'desc' : 'asc'));
    } else {
      setSortKey(key);
      setSortOrder('asc');
    }
  };

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

      <FilterBar filters={filters} setFilters={setFiltersState} />
      {Object.entries(filters).some(([, value]) => value) && (
        <div className="flex flex-wrap gap-2 bg-slate-50 rounded-xl p-3">
          {filters.status && (
            <button
              type="button"
              className="rounded-full border border-slate-200 bg-white px-3 py-1 text-xs text-slate-700 hover:bg-slate-100"
              onClick={() => setFiltersState((f) => ({ ...f, status: '' }))}
            >
              Status: {filters.status} ×
            </button>
          )}
          {filters.userId && (
            <button
              type="button"
              className="rounded-full border border-slate-200 bg-white px-3 py-1 text-xs text-slate-700 hover:bg-slate-100"
              onClick={() => setFiltersState((f) => ({ ...f, userId: '' }))}
            >
              Employee ID: {filters.userId} ×
            </button>
          )}
          {filters.category && (
            <button
              type="button"
              className="rounded-full border border-slate-200 bg-white px-3 py-1 text-xs text-slate-700 hover:bg-slate-100"
              onClick={() => setFiltersState((f) => ({ ...f, category: '' }))}
            >
              Category: {filters.category} ×
            </button>
          )}
          {filters.from && (
            <button
              type="button"
              className="rounded-full border border-slate-200 bg-white px-3 py-1 text-xs text-slate-700 hover:bg-slate-100"
              onClick={() => setFiltersState((f) => ({ ...f, from: '' }))}
            >
              From: {filters.from} ×
            </button>
          )}
          {filters.to && (
            <button
              type="button"
              className="rounded-full border border-slate-200 bg-white px-3 py-1 text-xs text-slate-700 hover:bg-slate-100"
              onClick={() => setFiltersState((f) => ({ ...f, to: '' }))}
            >
              To: {filters.to} ×
            </button>
          )}
          <button
            type="button"
            className="rounded-full bg-slate-900 text-white px-3 py-1 text-xs hover:bg-slate-800"
            onClick={() => {
              setFilters({ status: '', userId: '', category: '', from: '', to: '' });
              setPage(1);
            }}
          >
            Clear all
          </button>
        </div>
      )}
      <ExpenseTable
        items={sortedData}
        loading={isLoading}
        sortKey={sortKey}
        sortOrder={sortOrder}
        onSort={handleSort}
        onAction={(expense, action) => setModal({ open: true, expense, action })}
        onView={(expense) => setDetailExpense(expense)}
      />
      <ExpenseDetailModal
        expense={detailExpense}
        onClose={() => setDetailExpense(null)}
      />

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
