import mongoose from 'mongoose';
import Company from '../models/Company.js';
import Expense from '../models/Expense.js';
import User from '../models/User.js';
import { NotFoundError } from '../middleware/errorHandler.js';

const monthRange = (month, year) => {
  const now = new Date();
  const m = Number(month) || now.getMonth() + 1;
  const y = Number(year) || now.getFullYear();
  const start = new Date(Date.UTC(y, m - 1, 1, 0, 0, 0));
  const end = new Date(Date.UTC(y, m, 1, 0, 0, 0));
  return { start, end };
};

const baseMatch = (req, month, year) => {
  const { start, end } = monthRange(month, year);
  return {
    companyId: new mongoose.Types.ObjectId(req.user.companyId),
    date: { $gte: start, $lt: end }
  };
};

export const getSummary = async (req, res, next) => {
  try {
    const match = baseMatch(req, req.query.month, req.query.year);

    const [approvedAgg, pendingCount, vatAgg] = await Promise.all([
      Expense.aggregate([
        { $match: { ...match, status: 'approved' } },
        { $group: { _id: null, total: { $sum: { $ifNull: ['$amountBase', 0] } } } }
      ]),
      Expense.countDocuments({ ...match, status: 'pending' }),
      Expense.aggregate([
        { $match: { ...match, vatApplicable: true } },
        { $group: { _id: null, total: { $sum: { $ifNull: ['$vatAmount', 0] } } } }
      ])
    ]);

    const approvedTotal = approvedAgg[0]?.total || 0;
    const totalVAT = vatAgg[0]?.total || 0;

    res.json({
      success: true,
      data: {
        totalSpend: approvedTotal,
        pendingCount,
        approvedTotal,
        totalVAT
      }
    });
  } catch (err) {
    next(err);
  }
};

export const getByCategory = async (req, res, next) => {
  try {
    const match = baseMatch(req, req.query.month, req.query.year);

    const data = await Expense.aggregate([
      { $match: { ...match, status: 'approved' } },
      {
        $group: {
          _id: '$category',
          total: { $sum: { $ifNull: ['$amountBase', 0] } }
        }
      },
      { $project: { _id: 0, category: '$_id', total: 1 } },
      { $sort: { total: -1 } }
    ]);

    res.json({ success: true, data });
  } catch (err) {
    next(err);
  }
};

export const getByEmployee = async (req, res, next) => {
  try {
    const match = baseMatch(req, req.query.month, req.query.year);

    const totals = await Expense.aggregate([
      { $match: { ...match, status: 'approved' } },
      {
        $group: {
          _id: '$userId',
          total: { $sum: { $ifNull: ['$amountBase', 0] } }
        }
      }
    ]);

    const totalsMap = new Map(totals.map((t) => [t._id.toString(), t.total]));
    const employees = await User.find({ companyId: req.user.companyId, role: 'employee' })
      .select('name email')
      .lean();

    const data = employees
      .sort((a, b) => a.name.localeCompare(b.name))
      .map((employee) => ({
        userId: employee._id,
        name: employee.name,
        email: employee.email,
        total: totalsMap.get(employee._id.toString()) || 0
      }));

    res.json({ success: true, data });
  } catch (err) {
    next(err);
  }
};

export const getVatReport = async (req, res, next) => {
  try {
    const match = baseMatch(req, req.query.month, req.query.year);

    const company = await Company.findById(req.user.companyId).lean();
    if (!company) throw new NotFoundError('Company not found');

    const expenses = await Expense.find({ ...match, vatApplicable: true })
      .select('notes amount vatAmount date')
      .sort({ date: -1 })
      .lean();

    const totalVATClaimable = expenses.reduce((acc, e) => acc + (e.vatAmount || 0), 0);

    res.json({
      success: true,
      data: {
        totalVATClaimable,
        vatRate: company.vatRate,
        currency: company.baseCurrency,
        expenses: expenses.map((e) => ({
          id: e._id,
          merchant: e.notes || null,
          amount: e.amount,
          vatAmount: e.vatAmount,
          date: e.date
        }))
      }
    });
  } catch (err) {
    next(err);
  }
};
