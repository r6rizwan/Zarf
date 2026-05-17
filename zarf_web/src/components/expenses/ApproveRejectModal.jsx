import { useState } from 'react';

export default function ApproveRejectModal({ open, onClose, onConfirm, action }) {
  const [note, setNote] = useState('');

  if (!open) return null;

  return (
    <div className="fixed inset-0 bg-black/30 flex items-center justify-center p-4">
      <div className="bg-white rounded border p-4 w-full max-w-md">
        <h3 className="font-semibold">{action === 'approved' ? 'Approve' : 'Reject'} Expense</h3>
        <textarea
          className="w-full border rounded mt-3 p-2"
          rows={4}
          value={note}
          onChange={(e) => setNote(e.target.value)}
          placeholder="Comment (optional)"
        />
        <div className="flex justify-end gap-2 mt-3">
          <button className="px-3 py-1 border rounded" onClick={onClose}>Cancel</button>
          <button
            className="px-3 py-1 bg-slate-900 text-white rounded"
            onClick={() => {
              onConfirm(note);
              setNote('');
            }}
          >
            Confirm
          </button>
        </div>
      </div>
    </div>
  );
}
