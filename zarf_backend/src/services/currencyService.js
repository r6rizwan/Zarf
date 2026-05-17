import axios from 'axios';
import env from '../config/env.js';

const CACHE_TTL_MS = 60 * 60 * 1000;
const ratesCache = new Map();

export const convert = (amount, fromCurrency, toCurrency, rates) => {
  if (fromCurrency === toCurrency) return Number(amount);
  const rate = rates[fromCurrency];
  if (!rate) {
    throw new Error(`Missing exchange rate for currency: ${fromCurrency}`);
  }
  return Number((Number(amount) / Number(rate)).toFixed(2));
};

export const getRates = async (baseCurrency) => {
  const cacheKey = baseCurrency.toUpperCase();
  const cached = ratesCache.get(cacheKey);

  if (cached && Date.now() - cached.ts < CACHE_TTL_MS) {
    return cached.rates;
  }

  const url = `https://v6.exchangerate-api.com/v6/${env.CURRENCY_API_KEY}/latest/${cacheKey}`;
  const response = await axios.get(url);
  const rates = response.data?.conversion_rates;

  if (!rates) {
    throw new Error('Currency API returned no conversion rates');
  }

  ratesCache.set(cacheKey, { ts: Date.now(), rates });
  return rates;
};
