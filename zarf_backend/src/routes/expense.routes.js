import { Router } from 'express';
import { authMiddleware } from '../middleware/authMiddleware.js';
import { roleGuard } from '../middleware/roleGuard.js';
import { aiRateLimiter } from '../middleware/rateLimiter.js';
import { uploadMiddleware } from '../middleware/uploadMiddleware.js';
import {
  createExpense,
  deleteExpense,
  getExpenseById,
  getExpenses,
  parseExpenseReceipt,
  updateExpenseStatus
} from '../controllers/expenseController.js';

const router = Router();

router.use(authMiddleware);

router.get('/', getExpenses);
router.post('/', createExpense);
router.post('/parse-receipt', aiRateLimiter, uploadMiddleware, parseExpenseReceipt);
router.get('/:id', getExpenseById);
router.patch('/:id/status', roleGuard('manager', 'admin'), updateExpenseStatus);
router.delete('/:id', deleteExpense);

export default router;
