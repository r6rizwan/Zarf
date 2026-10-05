import mongoose from 'mongoose';

const expenseSchema = new mongoose.Schema({
  userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  companyId: { type: mongoose.Schema.Types.ObjectId, ref: 'Company', required: true },
  amount: { type: Number, required: true },
  currency: { type: String, required: true },
  amountBase: { type: Number, default: null },
  category: { type: String, required: true },
  notes: { type: String },
  receiptUrl: { type: String },
  vatApplicable: { type: Boolean, default: false },
  vatAmount: { type: Number, default: 0 },
  paymentMethod: { type: String },
  /** Vendor's Tax Registration Number extracted from the receipt (if present). */
  vendorTrn: { type: String, default: null },
  /**
   * Result of format-only TRN validation performed at submission time.
   *   not_provided  – no TRN was found on the receipt
   *   format_valid  – 15-digit UAE (starts with 1) or Saudi (starts with 3) TRN
   *   format_invalid – a TRN-like value was extracted but did not match known formats
   */
  trnStatus: {
    type: String,
    enum: ['not_provided', 'format_valid', 'format_invalid'],
    default: 'not_provided'
  },
  /** Names of warn-action corporate policies triggered at submission time. */
  policyFlags: [{ type: String }],
  status: {
    type: String,
    enum: ['pending', 'approved', 'rejected'],
    default: 'pending'
  },
  reviewedBy: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
  reviewNote: { type: String },
  date: { type: Date, required: true },
  createdAt: { type: Date, default: Date.now }
});

expenseSchema.index({ companyId: 1, createdAt: -1 });
expenseSchema.index({ companyId: 1, userId: 1, createdAt: -1 });
expenseSchema.index({ companyId: 1, status: 1, createdAt: -1 });
expenseSchema.index({ companyId: 1, category: 1, createdAt: -1 });
expenseSchema.index({ companyId: 1, date: -1 });

export default mongoose.model('Expense', expenseSchema);
