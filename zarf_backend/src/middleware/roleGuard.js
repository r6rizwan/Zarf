import { ForbiddenError } from './errorHandler.js';

export const roleGuard = (...roles) => (req, res, next) => {
  if (!req.user || !roles.includes(req.user.role)) {
    return next(new ForbiddenError());
  }
  next();
};
