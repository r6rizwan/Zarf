import bcrypt from 'bcrypt';
import mongoose from 'mongoose';
import { connectDB } from '../config/db.js';
import Company from '../models/Company.js';
import Expense from '../models/Expense.js';
import User from '../models/User.js';

const categories = ['Travel', 'Meals', 'Accommodation', 'Office Supplies', 'Client Entertainment', 'Other'];
const paymentMethods = ['Cash', 'Card', 'Bank Transfer'];
const statuses = ['pending', 'approved', 'rejected'];

const rand = (min, max) => Math.round(Math.random() * (max - min) + min);
const pick = (arr) => arr[rand(0, arr.length - 1)];

const createDemoUsers = async (companyId) => {
  const usersToCreate = [
    { name: 'Admin User', email: 'admin@zarf.demo', password: 'Admin@1234', role: 'admin' },
    { name: 'Manager One', email: 'manager1@zarf.demo', password: 'Manager@1234', role: 'manager' },
    { name: 'Manager Two', email: 'manager2@zarf.demo', password: 'Manager@1234', role: 'manager' },
    ...Array.from({ length: 5 }).map((_, idx) => ({
      name: `Employee ${idx + 1}`,
      email: `employee${idx + 1}@zarf.demo`,
      password: 'Employee@1234',
      role: 'employee'
    }))
  ];

  for (const user of usersToCreate) {
    const exists = await User.findOne({ email: user.email });
    if (exists) continue;

    const passwordHash = await bcrypt.hash(user.password, 12);
    await User.create({
      name: user.name,
      email: user.email,
      passwordHash,
      role: user.role,
      companyId
    });
  }
};

const createExpenses = async (companyId) => {
  const already = await Expense.countDocuments({ companyId });
  if (already >= 120) return;

  const managers = await User.find({ companyId, role: 'manager' }).select('_id');
  const employees = await User.find({ companyId, role: 'employee' }).select('_id');

  const records = [];
  for (let i = 0; i < 120; i++) {
    const amount = rand(50, 5000);
    const status = pick(statuses);
    const daysAgo = rand(0, 179);
    const date = new Date();
    date.setDate(date.getDate() - daysAgo);

    const vatApplicable = i < 30;
    const vatAmount = vatApplicable ? Number((amount * 0.05).toFixed(2)) : 0;

    records.push({
      userId: pick(employees)._id,
      companyId,
      amount,
      currency: 'AED',
      amountBase: amount,
      category: pick(categories),
      notes: `Seeded expense #${i + 1}`,
      vatApplicable,
      vatAmount,
      paymentMethod: pick(paymentMethods),
      status,
      reviewedBy: status === 'approved' ? pick(managers)._id : undefined,
      reviewNote: status === 'approved' ? 'Approved during seed' : status === 'rejected' ? 'Rejected during seed' : undefined,
      date
    });
  }

  await Expense.insertMany(records);
};

const seed = async () => {
  await connectDB();

  let company = await Company.findOne({ name: 'Zarf Demo Co.' });
  if (!company) {
    company = await Company.create({
      name: 'Zarf Demo Co.',
      baseCurrency: 'AED',
      vatRegistered: true,
      vatRate: 5,
      vatNumber: 'TRN-DEMO-001'
    });
  }

  const usersCount = await User.countDocuments({ companyId: company._id });
  const expensesCount = await Expense.countDocuments({ companyId: company._id });
  if (usersCount >= 8 && expensesCount >= 120) {
    console.log('already seeded');
    await mongoose.connection.close();
    return;
  }

  await createDemoUsers(company._id);
  await createExpenses(company._id);

  console.log('seed complete');
  await mongoose.connection.close();
};

seed().catch(async (err) => {
  console.error(err);
  await mongoose.connection.close();
  process.exit(1);
});
