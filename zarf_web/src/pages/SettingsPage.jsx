import { useEffect, useState } from 'react';
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';
import axiosClient from '../api/axiosClient';

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
    <div className="max-w-xl bg-white border rounded p-4 space-y-3">
      <h2 className="text-xl font-semibold">Settings</h2>
      <input className="w-full border rounded p-2" value={form.name} placeholder="Company Name" onChange={(e) => setForm((f) => ({ ...f, name: e.target.value }))} />
      <label className="flex items-center gap-2">
        <input type="checkbox" checked={form.vatRegistered} onChange={(e) => setForm((f) => ({ ...f, vatRegistered: e.target.checked }))} />
        VAT Registered
      </label>
      <input className="w-full border rounded p-2" type="number" value={form.vatRate} placeholder="VAT Rate" onChange={(e) => setForm((f) => ({ ...f, vatRate: e.target.value }))} />
      <input className="w-full border rounded p-2" value={form.vatNumber} placeholder="VAT Number" onChange={(e) => setForm((f) => ({ ...f, vatNumber: e.target.value }))} />
      <select className="w-full border rounded p-2" value={form.baseCurrency} onChange={(e) => setForm((f) => ({ ...f, baseCurrency: e.target.value }))}>
        <option value="AED">AED</option>
        <option value="SAR">SAR</option>
        <option value="USD">USD</option>
        <option value="EUR">EUR</option>
        <option value="INR">INR</option>
      </select>
      <button className="px-3 py-2 bg-slate-900 text-white rounded" onClick={() => saveMutation.mutate()}>
        Save
      </button>
    </div>
  );
}
