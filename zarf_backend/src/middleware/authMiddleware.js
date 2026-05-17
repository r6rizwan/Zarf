import jwt from 'jsonwebtoken';
import env from '../config/env.js';
import { UnauthorizedError } from './errorHandler.js';

export const authMiddleware = (req, res, next) => {
  try {
    const authHeader = req.headers.authorization;
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return next(new UnauthorizedError());
    }

    const token = authHeader.split(' ')[1];
    const decoded = jwt.verify(token, env.JWT_SECRET);

    req.user = {
      id: decoded.id,
      role: decoded.role,
      companyId: decoded.companyId
    };

    next();
  } catch (error) {
    next(new UnauthorizedError());
  }
};
