import { useEffect, useState } from 'react';
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';
import axiosClient from '../api/axiosClient';
import { Save } from 'lucide-react';

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
    mutationFn: async () => axiosClient.patch(`/company/${form.id}`, {
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

  return (
    <div className="max-w-xl">
      <h2 className="text-2xl font-bold text-slate-800 mb-6">Company Settings</h2>

      <div className="bg-white rounded-xl shadow-sm p-6 space-y-5">
        {/* Company Name */}
        <div>
          <label className="block text-sm font-medium text-slate-700 mb-1.5">Company Name</label>
          <input
            className="w-full border border-slate-300 rounded-md px-3.5 py-2.5 text-sm placeholder-slate-400 transition-colors"
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
            className="w-4 h-4 rounded border-slate-300 text-teal-600 focus:ring-teal-500"
          />
          <label htmlFor="vatRegistered" className="text-sm font-medium text-slate-700">VAT Registered</label>
        </div>

        {/* VAT Rate */}
        <div>
          <label className="block text-sm font-medium text-slate-700 mb-1.5">VAT Rate (%)</label>
          <input
            className="w-full border border-slate-300 rounded-md px-3.5 py-2.5 text-sm placeholder-slate-400 transition-colors"
            type="number"
            value={form.vatRate}
            placeholder="5"
            onChange={(e) => setForm((f) => ({ ...f, vatRate: e.target.value }))}
          />
        </div>

        {/* VAT Number */}
        <div>
          <label className="block text-sm font-medium text-slate-700 mb-1.5">VAT Number</label>
          <input
            className="w-full border border-slate-300 rounded-md px-3.5 py-2.5 text-sm placeholder-slate-400 transition-colors"
            value={form.vatNumber}
            placeholder="TRN1234567890"
            onChange={(e) => setForm((f) => ({ ...f, vatNumber: e.target.value }))}
          />
        </div>

        {/* Base Currency */}
        <div>
          <label className="block text-sm font-medium text-slate-700 mb-1.5">Base Currency</label>
          <select
            className="w-full border border-slate-300 rounded-md px-3.5 py-2.5 text-sm text-slate-700 transition-colors"
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
          className="inline-flex items-center gap-2 bg-teal-600 hover:bg-teal-700 text-white font-medium rounded-md px-5 py-2.5 text-sm transition-colors"
          onClick={() => saveMutation.mutate()}
        >
          <Save className="w-4 h-4" />
          Save Changes
        </button>
      </div>
    </div>
  );
}
