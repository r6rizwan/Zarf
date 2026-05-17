import { Router } from 'express';
import {
  getByCategory,
  getByEmployee,
  getSummary,
  getVatReport
} from '../controllers/analyticsController.js';
import { authMiddleware } from '../middleware/authMiddleware.js';
import { roleGuard } from '../middleware/roleGuard.js';

const router = Router();

router.use(authMiddleware);
router.use(roleGuard('manager', 'admin'));

router.get('/summary', getSummary);
router.get('/by-category', getByCategory);
router.get('/by-employee', getByEmployee);
router.get('/vat-report', getVatReport);

export default router;
