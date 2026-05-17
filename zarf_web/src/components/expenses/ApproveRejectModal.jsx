import { useState } from 'react';
import { Loader2 } from 'lucide-react';

export default function ApproveRejectModal({ open, onClose, onConfirm, action, loading }) {
  const [note, setNote] = useState('');

  if (!open) return null;

  const isApprove = action === 'approved';

  return (
    <div className="fixed inset-0 bg-black/40 backdrop-blur-sm flex items-center justify-center p-4 z-50">
      <div className="bg-white rounded-xl shadow-xl p-6 w-full max-w-md animate-in">
        <h3 className="text-lg font-semibold text-slate-800">
          {isApprove ? 'Approve' : 'Reject'} Expense
        </h3>
        <p className="text-sm text-slate-500 mt-1">
          {isApprove ? 'Confirm approval of this expense claim.' : 'Provide a reason for rejecting this expense.'}
        </p>
        <textarea
          className="w-full border border-slate-300 rounded-lg mt-4 p-3 text-sm placeholder-slate-400 resize-none transition-colors"
          rows={4}
          value={note}
          onChange={(e) => setNote(e.target.value)}
          placeholder="Add a comment (optional)"
          disabled={loading}
        />
        <div className="flex justify-end gap-3 mt-4">
          <button
            className="px-4 py-2 text-sm font-medium border border-slate-300 rounded-lg text-slate-600 hover:bg-slate-50 transition-colors disabled:opacity-40 disabled:cursor-not-allowed"
            onClick={onClose}
            disabled={loading}
          >
            Cancel
          </button>
          <button
            className={`inline-flex items-center gap-2 px-4 py-2 text-sm font-medium rounded-lg text-white transition-colors disabled:opacity-60 disabled:cursor-not-allowed ${
              isApprove
                ? 'bg-emerald-600 hover:bg-emerald-700'
                : 'bg-rose-600 hover:bg-rose-700'
            }`}
            disabled={loading}
            onClick={() => {
              onConfirm(note);
              setNote('');
            }}
          >
            {loading && <Loader2 className="w-4 h-4 animate-spin" />}
            {loading
              ? (isApprove ? 'Approving…' : 'Rejecting…')
              : (isApprove ? 'Approve' : 'Reject')
            }
          </button>
        </div>
      </div>
    </div>
  );
}
