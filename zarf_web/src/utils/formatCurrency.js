export const formatAmount = (amount, currency = 'AED') => {
  // If a non-numeric string (e.g. 'Loading...') is provided, return it unchanged
  if (typeof amount === 'string' && isNaN(Number(amount))) {
    return amount;
  }

  const value = Number(amount ?? 0) || 0;
  return new Intl.NumberFormat('en-US', {
    style: 'currency',
    currency,
    currencyDisplay: 'code',
    minimumFractionDigits: 2,
    maximumFractionDigits: 2
  }).format(value);
};
