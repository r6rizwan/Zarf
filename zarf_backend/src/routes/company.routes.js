import { Router } from 'express';
import { authMiddleware } from '../middleware/authMiddleware.js';
import { getCompanyById, updateCompany } from '../controllers/companyController.js';
import { roleGuard } from '../middleware/roleGuard.js';

const router = Router();

router.use(authMiddleware);
router.get('/:id', getCompanyById);
router.patch('/:id', roleGuard('admin'), updateCompany);

export default router;
