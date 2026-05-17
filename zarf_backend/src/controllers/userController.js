import User from '../models/User.js';
import { ValidationError } from '../middleware/errorHandler.js';

export const updateFcmToken = async (req, res, next) => {
  try {
    const { fcmToken } = req.body;
    if (!fcmToken || typeof fcmToken !== 'string') {
      throw new ValidationError('fcmToken is required');
    }

    await User.findByIdAndUpdate(req.user.id, { fcmToken });
    res.json({ success: true, message: 'FCM token updated' });
  } catch (err) {
    next(err);
  }
};
