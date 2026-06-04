import fs from 'fs/promises';
import { v2 as cloudinary } from 'cloudinary';
import Company from '../models/Company.js';
import Expense from '../models/Expense.js';
import User from '../models/User.js';
import { cleanupTempFile } from '../middleware/uploadMiddleware.js';
import { ForbiddenError, NotFoundError, ValidationError } from '../middleware/errorHandler.js';
import { convert, getRates } from '../services/currencyService.js';
import { sendNotification } from '../services/fcmService.js';
import { parseReceipt } from '../services/groqService.js';

cloudinary.config({ secure: true });

export const getExpenses = async (req, res, next) => {
  try {
    const {
      status,
      userId,
      from,
      to,
      category,
      page = 1,
      limit = 20
    } = req.query;

    const query = { companyId: req.user.companyId };

    if (req.user.role === 'employee') {
      query.userId = req.user.id;
    } else if (userId) {
      query.userId = userId;
    }

    if (status) query.status = status;
    if (category) query.category = category;
    if (from || to) {
      query.date = {};
      if (from) query.date.$gte = new Date(from);
      if (to) {
        const [year, month, day] = to.split('-').map(Number);
        const endOfDay = new Date(year, month - 1, day, 23, 59, 59, 999);
        query.date.$lte = endOfDay;
      }
    }

    const parsedPage = Number(page);
    const parsedLimit = Number(limit);
    const skip = (parsedPage - 1) * parsedLimit;

    const sortBy = req.query.sortBy || 'date';
    const sortOrderParam = req.query.sortOrder === 'asc' ? 1 : -1;
    const sortFieldMap = {
      employee: 'userId',
      merchant: 'notes',
      amount: 'amountBase',
      vat: 'vatAmount',
      category: 'category',
      date: 'date',
      status: 'status'
    };

    if (!Object.keys(sortFieldMap).includes(sortBy)) {
      throw new ValidationError('sortBy must be one of employee, merchant, amount, vat, category, date, status');
    }

    const sortField = sortFieldMap[sortBy];

    if (from && to) {
      const fromDate = new Date(from);
      const toDate = new Date(to);
      if (Number.isNaN(fromDate.getTime()) || Number.isNaN(toDate.getTime())) {
        throw new ValidationError('Invalid from/to date');
      }
      if (fromDate > toDate) {
        throw new ValidationError('from date cannot be after to date');
      }
    }

    const [data, total] = await Promise.all([
      Expense.find(query)
        .select(
          'userId companyId amount currency amountBase category notes receiptUrl vatApplicable vatAmount paymentMethod status reviewedBy reviewNote date createdAt'
        )
        .populate('userId', 'name email')
        .sort({ [sortField]: sortOrderParam })
        .skip(skip)
        .limit(parsedLimit)
        .lean(),
      Expense.countDocuments(query)
    ]);

    res.json({
      success: true,
      data,
      total,
      page: parsedPage,
      totalPages: Math.ceil(total / parsedLimit)
    });
  } catch (err) {
    next(err);
  }
};

export const createExpense = async (req, res, next) => {
  try {
    const {
      amount,
      currency,
      category,
      notes,
      vatApplicable,
      vatAmount,
      paymentMethod,
      date
    } = req.body;

    if (!amount || !currency || !category || !date) {
      throw new ValidationError('amount, currency, category and date are required');
    }

    const parsedAmount = Number(amount);
    if (Number.isNaN(parsedAmount) || parsedAmount <= 0) {
      throw new ValidationError('amount must be a positive number');
    }

    if (typeof currency !== 'string' || currency.trim().length !== 3) {
      throw new ValidationError('currency must be a valid 3-letter code');
    }

    const expenseDate = new Date(date);
    if (Number.isNaN(expenseDate.getTime())) {
      throw new ValidationError('date must be a valid date');
    }

    const company = await Company.findById(req.user.companyId).select('baseCurrency');
    if (!company) throw new NotFoundError('Company not found');

    let amountBase = null;
    const fromCurrency = String(currency).toUpperCase();
    const toCurrency = String(company.baseCurrency).toUpperCase();

    if (fromCurrency === toCurrency) {
      amountBase = Number(amount);
    } else {
      const rates = await getRates(toCurrency);
      amountBase = convert(amount, fromCurrency, toCurrency, rates);
    }

    const expense = await Expense.create({
      userId: req.user.id,
      companyId: req.user.companyId,
      amount,
      currency: fromCurrency,
      category,
      notes,
      vatApplicable,
      vatAmount,
      paymentMethod,
      date,
      amountBase
    });

    res.status(201).json({ success: true, data: expense });
  } catch (err) {
    next(err);
  }
};

export const getExpenseById = async (req, res, next) => {
  try {
    const expense = await Expense.findById(req.params.id).lean();
    if (!expense) throw new NotFoundError('Expense not found');

    if (
      req.user.role === 'employee' &&
      expense.userId.toString() !== req.user.id
    ) {
      throw new ForbiddenError();
    }

    res.json({ success: true, data: expense });
  } catch (err) {
    next(err);
  }
};

export const updateExpenseStatus = async (req, res, next) => {
  try {
    const { status, reviewNote } = req.body;
    if (!['approved', 'rejected'].includes(status)) {
      throw new ValidationError('status must be approved or rejected');
    }

    const expense = await Expense.findById(req.params.id);
    if (!expense) throw new NotFoundError('Expense not found');

    expense.status = status;
    expense.reviewNote = reviewNote;
    expense.reviewedBy = req.user.id;
    await expense.save();

    const owner = await User.findById(expense.userId).select('fcmToken');
    if (status === 'approved') {
      await sendNotification(
        owner?.fcmToken,
        'Expense Approved',
        'Your expense has been approved'
      );
    }
    if (status === 'rejected') {
      await sendNotification(
        owner?.fcmToken,
        'Expense Rejected',
        'Your expense was rejected'
      );
    }

    res.json({ success: true, data: expense });
  } catch (err) {
    next(err);
  }
};

export const deleteExpense = async (req, res, next) => {
  try {
    const expense = await Expense.findById(req.params.id);
    if (!expense) throw new NotFoundError('Expense not found');

    if (req.user.role === 'employee') {
      if (expense.userId.toString() !== req.user.id || expense.status !== 'pending') {
        throw new ForbiddenError('Employees can only delete their own pending expense');
      }
    }

    await expense.deleteOne();
    res.json({ success: true, message: 'Expense deleted' });
  } catch (err) {
    next(err);
  }
};

export const parseExpenseReceipt = async (req, res, next) => {
  let localPath;
  let cloudinaryPublicId;

  try {
    if (!req.file) {
      throw new ValidationError('Receipt image is required');
    }

    localPath = req.file.path;

    const uploadResult = await cloudinary.uploader.upload(localPath, {
      folder: 'zarf/receipts/temp',
      public_id: `temp_${req.user.id}_${Date.now()}`,
      overwrite: true,
      resource_type: 'image'
    });

    cloudinaryPublicId = uploadResult.public_id;

    const imageBuffer = await fs.readFile(localPath);
    const data = await parseReceipt({
      imageBuffer,
      mimetype: req.file.mimetype
    });

    res.json({ success: true, data });
  } catch (err) {
    next(err);
  } finally {
    if (cloudinaryPublicId) {
      await cloudinary.uploader.destroy(cloudinaryPublicId, { resource_type: 'image' });
    }
    await cleanupTempFile(localPath);
  }
};
