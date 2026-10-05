import mongoose from 'mongoose';

const policySchema = new mongoose.Schema({
  companyId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Company',
    required: true
  },
  /** Human-readable label shown to managers in the dashboard. */
  name: { type: String, required: true, trim: true },
  /**
   * amount_limit      – flag/block when expense.amountBase exceeds `threshold`.
   * weekend_submission – flag/block when the expense date falls on a weekend (Fri–Sat in GCC, Sat–Sun otherwise).
   */
  type: {
    type: String,
    enum: ['amount_limit', 'weekend_submission'],
    required: true
  },
  /** Restrict this rule to one expense category. null = applies to all categories. */
  category: { type: String, default: null },
  /** Maximum allowed spend in the company's base currency. Required for amount_limit. */
  threshold: { type: Number, default: null },
  /**
   * warn  – expense is created but policyFlags is populated (visible to managers).
   * block – expense creation is rejected with a 400 ValidationError.
   */
  action: {
    type: String,
    enum: ['warn', 'block'],
    default: 'warn'
  },
  enabled: { type: Boolean, default: true },
  createdAt: { type: Date, default: Date.now }
});

policySchema.index({ companyId: 1, enabled: 1 });

export default mongoose.model('Policy', policySchema);
