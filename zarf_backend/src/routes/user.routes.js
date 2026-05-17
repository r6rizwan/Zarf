import { Router } from 'express';
import { authMiddleware } from '../middleware/authMiddleware.js';
import { updateFcmToken } from '../controllers/userController.js';

const router = Router();

router.use(authMiddleware);
router.patch('/fcm-token', updateFcmToken);

export default router;
