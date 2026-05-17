import mongoose from 'mongoose';

const companySchema = new mongoose.Schema({
  name: { type: String, required: true },
  baseCurrency: { type: String, default: 'AED' },
  vatRegistered: { type: Boolean, default: false },
  vatRate: { type: Number, default: 5 },
  vatNumber: { type: String }
});

export default mongoose.model('Company', companySchema);
