import express from 'express';
import cors from 'cors';
import env from './config/env.js';
import { connectDB } from './config/db.js';
import authRoutes from './routes/auth.routes.js';
import expenseRoutes from './routes/expense.routes.js';
import companyRoutes from './routes/company.routes.js';
import analyticsRoutes from './routes/analytics.routes.js';
import userRoutes from './routes/user.routes.js';
import { generalLimiter } from './middleware/rateLimiter.js';
import { errorHandler } from './middleware/errorHandler.js';
import { securityHeaders } from './middleware/security.js';

const app = express();

// Trust reverse proxy (Render, Heroku, AWS ALB) for express-rate-limit IP detection
app.set('trust proxy', 1);

app.use(securityHeaders);

app.use(
  cors({
    origin: env.CLIENT_URL,
    methods: ['GET', 'POST', 'PATCH', 'DELETE', 'OPTIONS'],
    allowedHeaders: ['Content-Type', 'Authorization'],
    credentials: true
  })
);

app.use(express.json());
app.use(generalLimiter);

app.get('/api/v1/health', (req, res) => {
  res.json({ success: true, uptime: process.uptime() });
});

app.use('/api/v1/auth', authRoutes);
app.use('/api/v1/expenses', expenseRoutes);
app.use('/api/v1/analytics', analyticsRoutes);
app.use('/api/v1/company', companyRoutes);
app.use('/api/v1/users', userRoutes);

app.use(errorHandler);

connectDB().then(() => {
  app.listen(env.PORT, () => {
    console.log(`Server listening on port ${env.PORT}`);
  });
});
