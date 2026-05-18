export const securityHeaders = (req, res, next) => {
  // Prevent clickjacking by restricting page embedding to same origin
  res.setHeader('X-Frame-Options', 'SAMEORIGIN');

  // Prevent MIME-sniffing
  res.setHeader('X-Content-Type-Options', 'nosniff');

  // Control referrer information sent in headers
  res.setHeader('Referrer-Policy', 'strict-origin-when-cross-origin');

  // Prevent cross-site scripting (legacy block)
  res.setHeader('X-XSS-Protection', '1; mode=block');

  // Enforce HTTPS
  res.setHeader('Strict-Transport-Security', 'max-age=31536000; includeSubDomains; preload');

  // Content Security Policy
  res.setHeader(
    'Content-Security-Policy',
    "default-src 'self'; script-src 'self' 'unsafe-inline'; style-src 'self' 'unsafe-inline'; img-src 'self' data: https:; connect-src 'self' https:;"
  );

  next();
};
