import Company from '../models/Company.js';
import User from '../models/User.js';
import { NotFoundError } from '../middleware/errorHandler.js';

export const getCompanyById = async (req, res, next) => {
  try {
    const id =
      req.params.id === 'me'
        ? (await User.findById(req.user.id).select('companyId'))?.companyId
        : req.params.id;

    const company = await Company.findById(id);
    if (!company) throw new NotFoundError('Company not found');

    res.json({ success: true, data: company });
  } catch (err) {
    next(err);
  }
};

export const updateCompany = async (req, res, next) => {
  try {
    const { name, vatRegistered, vatRate, vatNumber, baseCurrency } = req.body;

    const company = await Company.findById(req.params.id);
    if (!company) throw new NotFoundError('Company not found');

    if (name !== undefined) company.name = name;
    if (vatRegistered !== undefined) company.vatRegistered = vatRegistered;
    if (vatRate !== undefined) company.vatRate = vatRate;
    if (vatNumber !== undefined) company.vatNumber = vatNumber;
    if (baseCurrency !== undefined) company.baseCurrency = baseCurrency;

    await company.save();

    res.json({ success: true, data: company });
  } catch (err) {
    next(err);
  }
};
