import { Router } from 'express';
import { authMiddleware } from '../middleware/authMiddleware.js';
import { roleGuard } from '../middleware/roleGuard.js';
import {
  getPolicies,
  createPolicy,
  updatePolicy,
  deletePolicy
} from '../controllers/policyController.js';

const router = Router();

router.use(authMiddleware);

// All authenticated users can read policies (managers need them to review flags)
router.get('/', getPolicies);

// Only admins can mutate policies
router.post('/', roleGuard('admin'), createPolicy);
router.patch('/:id', roleGuard('admin'), updatePolicy);
router.delete('/:id', roleGuard('admin'), deletePolicy);

export default router;
