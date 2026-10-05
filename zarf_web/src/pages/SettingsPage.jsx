import { useEffect, useState } from 'react';
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';
import axiosClient from '../api/axiosClient';
import { Save, Loader2, Plus, Trash2, ShieldAlert, ShieldCheck } from 'lucide-react';

const EXPENSE_CATEGORIES = [
  'Travel', 'Meals', 'Accommodation', 'Office Supplies', 'Client Entertainment', 'Other'
];

// ── Policy row ──────────────────────────────────────────────────────────────

function PolicyRow({ policy, baseCurrency = 'AED', onToggle, onDelete, isPending }) {
  const typeLabel =
    policy.type === 'amount_limit' ? 'Amount Limit' : 'Weekend Submission';

  return (
    <div
      className={`flex items-center gap-3 rounded-lg border p-3 transition-opacity ${
        policy.enabled ? 'border-slate-200 bg-white' : 'border-slate-100 bg-slate-50 opacity-60'
      }`}
    >
      <input
        type="checkbox"
        checked={policy.enabled}
        disabled={isPending}
        onChange={(e) => onToggle(policy._id, e.target.checked)}
        className="h-4 w-4 rounded border-slate-300 text-teal-600 focus:ring-teal-500"
      />

      <div className="min-w-0 flex-1">
        <p className="truncate text-sm font-medium text-slate-800">{policy.name}</p>
        <p className="mt-0.5 text-xs text-slate-500">
          {typeLabel}
          {policy.category ? ` · ${policy.category}` : ' · All Categories'}
          {policy.threshold != null ? ` · >${policy.threshold} ${baseCurrency}` : ''}
        </p>
      </div>

      {policy.action === 'block' ? (
        <span className="inline-flex items-center gap-1 rounded-full bg-red-100 px-2.5 py-0.5 text-xs font-medium text-red-700">
          <ShieldAlert className="h-3 w-3" /> Block
        </span>
      ) : (
        <span className="inline-flex items-center gap-1 rounded-full bg-amber-100 px-2.5 py-0.5 text-xs font-medium text-amber-700">
          <ShieldCheck className="h-3 w-3" /> Warn
        </span>
      )}

      <button
        title="Delete policy"
        onClick={() => onDelete(policy._id)}
        className="text-slate-400 transition-colors hover:text-red-500"
      >
        <Trash2 className="h-4 w-4" />
      </button>
    </div>
  );
}

// ── Add policy form ─────────────────────────────────────────────────────────

const defaultNewPolicy = {
  name: '',
  type: 'amount_limit',
  category: '',
  threshold: '',
  action: 'warn'
};

function AddPolicyForm({ baseCurrency = 'AED', onSave, onCancel, isPending }) {
  const [form, setForm] = useState(defaultNewPolicy);

  const isValid =
    form.name.trim().length > 0 &&
    (form.type !== 'amount_limit' || (form.threshold !== '' && Number(form.threshold) > 0));

  return (
    <div className="space-y-3 rounded-lg border border-teal-200 bg-teal-50/40 p-4">
      <p className="text-sm font-semibold text-slate-700">New Policy</p>

      <input
        className="w-full rounded-md border border-slate-300 px-3 py-2 text-sm placeholder-slate-400"
        placeholder="Policy name (e.g. Meal Spending Limit)"
        value={form.name}
        onChange={(e) => setForm((f) => ({ ...f, name: e.target.value }))}
      />

      <div className="grid grid-cols-2 gap-3">
        <div>
          <label className="mb-1 block text-xs text-slate-500">Type</label>
          <select
            className="w-full rounded-md border border-slate-300 px-3 py-2 text-sm text-slate-700"
            value={form.type}
            onChange={(e) => setForm((f) => ({ ...f, type: e.target.value, threshold: '' }))}
          >
            <option value="amount_limit">Amount Limit</option>
            <option value="weekend_submission">Weekend Submission</option>
          </select>
        </div>

        <div>
          <label className="mb-1 block text-xs text-slate-500">Action</label>
          <select
            className="w-full rounded-md border border-slate-300 px-3 py-2 text-sm text-slate-700"
            value={form.action}
            onChange={(e) => setForm((f) => ({ ...f, action: e.target.value }))}
          >
            <option value="warn">Warn (flag expense)</option>
            <option value="block">Block (reject expense)</option>
          </select>
        </div>
      </div>

      <div className="grid grid-cols-2 gap-3">
        <div>
          <label className="mb-1 block text-xs text-slate-500">Category (optional)</label>
          <select
            className="w-full rounded-md border border-slate-300 px-3 py-2 text-sm text-slate-700"
            value={form.category}
            onChange={(e) => setForm((f) => ({ ...f, category: e.target.value }))}
          >
            <option value="">All Categories</option>
            {EXPENSE_CATEGORIES.map((c) => (
              <option key={c} value={c}>{c}</option>
            ))}
          </select>
        </div>

        {form.type === 'amount_limit' && (
          <div>
            <label className="mb-1 block text-xs text-slate-500">Max Amount ({baseCurrency})</label>
            <input
              className="w-full rounded-md border border-slate-300 px-3 py-2 text-sm placeholder-slate-400"
              type="number"
              min="1"
              placeholder="300"
              value={form.threshold}
              onChange={(e) => setForm((f) => ({ ...f, threshold: e.target.value }))}
            />
          </div>
        )}
      </div>

      <div className="flex gap-2 pt-1">
        <button
          onClick={() =>
            onSave({
              name: form.name.trim(),
              type: form.type,
              category: form.category || undefined,
              threshold: form.threshold ? Number(form.threshold) : undefined,
              action: form.action
            })
          }
          disabled={!isValid || isPending}
          className="inline-flex items-center gap-1.5 rounded-md bg-teal-600 px-4 py-2 text-sm font-medium text-white transition-colors hover:bg-teal-700 disabled:cursor-not-allowed disabled:opacity-50"
        >
          {isPending && <Loader2 className="h-3.5 w-3.5 animate-spin" />}
          Add Policy
        </button>
        <button
          onClick={onCancel}
          className="px-3 py-2 text-sm text-slate-600 hover:text-slate-900"
        >
          Cancel
        </button>
      </div>
    </div>
  );
}

// ── Main page ───────────────────────────────────────────────────────────────

export default function SettingsPage() {
  const qc = useQueryClient();
  const [form, setForm] = useState({
    id: '',
    name: '',
    vatRegistered: false,
    vatRate: 0,
    vatNumber: '',
    baseCurrency: 'AED'
  });
  const [showAddForm, setShowAddForm] = useState(false);

  // Company settings
  const companyQuery = useQuery({
    queryKey: ['company-me'],
    queryFn: async () => (await axiosClient.get('/company/me')).data.data
  });

  useEffect(() => {
    if (!companyQuery.data) return;
    setForm({
      id: companyQuery.data._id,
      name: companyQuery.data.name || '',
      vatRegistered: !!companyQuery.data.vatRegistered,
      vatRate: companyQuery.data.vatRate ?? 0,
      vatNumber: companyQuery.data.vatNumber || '',
      baseCurrency: companyQuery.data.baseCurrency || 'AED'
    });
  }, [companyQuery.data]);

  const saveMutation = useMutation({
    mutationFn: async () =>
      axiosClient.patch(`/company/${form.id}`, {
        name: form.name,
        vatRegistered: form.vatRegistered,
        vatRate: Number(form.vatRate),
        vatNumber: form.vatNumber,
        baseCurrency: form.baseCurrency
      }),
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ['analytics-summary'] });
      qc.invalidateQueries({ queryKey: ['analytics-category'] });
      qc.invalidateQueries({ queryKey: ['analytics-vat'] });
      qc.invalidateQueries({ queryKey: ['company-me'] });
    }
  });

  // Policies
  const policiesQuery = useQuery({
    queryKey: ['policies'],
    queryFn: async () => (await axiosClient.get('/policies')).data.data
  });

  const createPolicyMutation = useMutation({
    mutationFn: async (data) => axiosClient.post('/policies', data),
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ['policies'] });
      setShowAddForm(false);
    }
  });

  const updatePolicyMutation = useMutation({
    mutationFn: async ({ id, enabled }) =>
      axiosClient.patch(`/policies/${id}`, { enabled }),
    onSuccess: () => qc.invalidateQueries({ queryKey: ['policies'] })
  });

  const deletePolicyMutation = useMutation({
    mutationFn: async (id) => axiosClient.delete(`/policies/${id}`),
    onSuccess: () => qc.invalidateQueries({ queryKey: ['policies'] })
  });

  const policies = policiesQuery.data || [];

  return (
    <div className="max-w-xl space-y-8">
      <h2 className="text-2xl font-bold text-slate-800">Company Settings</h2>

      {/* ── Company details ──────────────────────────────────────────────── */}
      <div className="rounded-xl bg-white p-6 shadow-sm space-y-5">
        <h3 className="text-base font-semibold text-slate-700">General</h3>

        {/* Company Name */}
        <div>
          <label className="mb-1.5 block text-sm font-medium text-slate-700">Company Name</label>
          <input
            className="w-full rounded-md border border-slate-300 px-3.5 py-2.5 text-sm placeholder-slate-400 transition-colors"
            value={form.name}
            placeholder="Acme Corp"
            onChange={(e) => setForm((f) => ({ ...f, name: e.target.value }))}
          />
        </div>

        {/* VAT Registered */}
        <div className="flex items-center gap-3">
          <input
            id="vatRegistered"
            type="checkbox"
            checked={form.vatRegistered}
            onChange={(e) => setForm((f) => ({ ...f, vatRegistered: e.target.checked }))}
            className="h-4 w-4 rounded border-slate-300 text-teal-600 focus:ring-teal-500"
          />
          <label htmlFor="vatRegistered" className="text-sm font-medium text-slate-700">
            VAT Registered
          </label>
        </div>

        {/* VAT Rate */}
        <div>
          <label className="mb-1.5 block text-sm font-medium text-slate-700">VAT Rate (%)</label>
          <input
            className="w-full rounded-md border border-slate-300 px-3.5 py-2.5 text-sm placeholder-slate-400 transition-colors"
            type="number"
            value={form.vatRate}
            placeholder="5"
            onChange={(e) => setForm((f) => ({ ...f, vatRate: e.target.value }))}
          />
        </div>

        {/* VAT Number */}
        <div>
          <label className="mb-1.5 block text-sm font-medium text-slate-700">
            VAT / TRN Number
          </label>
          <input
            className="w-full rounded-md border border-slate-300 px-3.5 py-2.5 text-sm placeholder-slate-400 transition-colors"
            value={form.vatNumber}
            placeholder="100123456789012"
            onChange={(e) => setForm((f) => ({ ...f, vatNumber: e.target.value }))}
          />
        </div>

        {/* Base Currency */}
        <div>
          <label className="mb-1.5 block text-sm font-medium text-slate-700">Base Currency</label>
          <select
            className="w-full rounded-md border border-slate-300 px-3.5 py-2.5 text-sm text-slate-700 transition-colors"
            value={form.baseCurrency}
            onChange={(e) => setForm((f) => ({ ...f, baseCurrency: e.target.value }))}
          >
            <option value="AED">AED</option>
            <option value="SAR">SAR</option>
            <option value="USD">USD</option>
            <option value="EUR">EUR</option>
            <option value="INR">INR</option>
          </select>
        </div>

        {/* Save */}
        <button
          className="inline-flex items-center gap-2 rounded-md bg-teal-600 px-5 py-2.5 text-sm font-medium text-white transition-colors hover:bg-teal-700 disabled:cursor-not-allowed disabled:opacity-60"
          onClick={() => saveMutation.mutate()}
          disabled={saveMutation.isPending}
        >
          {saveMutation.isPending ? (
            <Loader2 className="h-4 w-4 animate-spin" />
          ) : (
            <Save className="h-4 w-4" />
          )}
          {saveMutation.isPending ? 'Saving…' : 'Save Changes'}
        </button>
      </div>

      {/* ── Spending policies ─────────────────────────────────────────────── */}
      <div className="rounded-xl bg-white p-6 shadow-sm space-y-4">
        <div className="flex items-start justify-between gap-4">
          <div>
            <h3 className="text-base font-semibold text-slate-700">Spending Policies</h3>
            <p className="mt-0.5 text-sm text-slate-500">
              Auto-flag or block expenses that break company rules.
            </p>
          </div>
          {!showAddForm && (
            <button
              onClick={() => setShowAddForm(true)}
              className="inline-flex shrink-0 items-center gap-1.5 rounded-md border border-slate-300 px-3 py-1.5 text-sm font-medium text-slate-700 transition-colors hover:bg-slate-50"
            >
              <Plus className="h-4 w-4" /> Add Policy
            </button>
          )}
        </div>

        {policiesQuery.isLoading && (
          <div className="py-4 text-center">
            <Loader2 className="mx-auto h-5 w-5 animate-spin text-slate-400" />
          </div>
        )}

        {!policiesQuery.isLoading && policies.length === 0 && !showAddForm && (
          <p className="py-6 text-center text-sm text-slate-400">
            No policies yet. Add one to start enforcing spending rules.
          </p>
        )}

        <div className="space-y-2">
          {policies.map((policy) => (
            <PolicyRow
              key={policy._id}
              policy={policy}
              baseCurrency={form.baseCurrency}
              isPending={updatePolicyMutation.isPending || deletePolicyMutation.isPending}
              onToggle={(id, enabled) => updatePolicyMutation.mutate({ id, enabled })}
              onDelete={(id) => deletePolicyMutation.mutate(id)}
            />
          ))}
        </div>

        {showAddForm && (
          <AddPolicyForm
            baseCurrency={form.baseCurrency}
            isPending={createPolicyMutation.isPending}
            onSave={(data) => createPolicyMutation.mutate(data)}
            onCancel={() => setShowAddForm(false)}
          />
        )}
      </div>
    </div>
  );
}
