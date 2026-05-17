import dotenv from 'dotenv';

dotenv.config();

const requiredKeys = [
  'PORT',
  'MONGO_URI',
  'JWT_SECRET',
  'JWT_REFRESH_SECRET',
  'JWT_EXPIRES_IN',
  'JWT_REFRESH_EXPIRES_IN',
  'CLIENT_URL',
  'GROQ_API_KEY',
  'CLOUDINARY_URL',
  'CURRENCY_API_KEY'
];

for (const key of requiredKeys) {
  if (!process.env[key]) {
    throw new Error(`Missing required env var: ${key}. Check .env.example.`);
  }
}

const env = {
  PORT: process.env.PORT,
  MONGO_URI: process.env.MONGO_URI,
  JWT_SECRET: process.env.JWT_SECRET,
  JWT_REFRESH_SECRET: process.env.JWT_REFRESH_SECRET,
  JWT_EXPIRES_IN: process.env.JWT_EXPIRES_IN,
  JWT_REFRESH_EXPIRES_IN: process.env.JWT_REFRESH_EXPIRES_IN,
  CLIENT_URL: process.env.CLIENT_URL,
  GROQ_API_KEY: process.env.GROQ_API_KEY,
  CLOUDINARY_URL: process.env.CLOUDINARY_URL,
  CURRENCY_API_KEY: process.env.CURRENCY_API_KEY,
  NODE_ENV: process.env.NODE_ENV || 'development'
};

export default env;
