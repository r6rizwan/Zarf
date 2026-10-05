/**
 * UAE / Saudi TRN (Tax Registration Number) format validation.
 *
 * The UAE Federal Tax Authority (FTA) and Saudi ZATCA do NOT expose a public
 * REST API for automated TRN lookup. Validation here is format-only.
 *
 * Publicly documented format rules:
 *   UAE TRN   – exactly 15 digits, always starts with 1  (e.g. 100123456789012)
 *   Saudi VAT – exactly 15 digits, always starts with 3  (e.g. 300123456789012)
 *
 * For live entity verification direct users to the official portals:
 *   UAE:   https://tax.gov.ae  → "TRN Verification"
 *   Saudi: https://zatca.gov.sa → "VAT Number Verification"
 */

const UAE_TRN_REGEX = /^1\d{14}$/;
const SAUDI_VAT_REGEX = /^3\d{14}$/;

/**
 * Validates a TRN string and returns a status descriptor.
 *
 * @param {string|null|undefined} trn
 * @returns {{ status: 'not_provided'|'format_valid'|'format_invalid', country: 'UAE'|'Saudi'|null }}
 */
export function validateTrn(trn) {
  if (!trn || typeof trn !== 'string' || trn.trim() === '') {
    return { status: 'not_provided', country: null };
  }

  // Strip spaces and hyphens that may appear in human-typed input
  const cleaned = trn.replace(/[\s-]/g, '');

  if (UAE_TRN_REGEX.test(cleaned)) {
    return { status: 'format_valid', country: 'UAE' };
  }

  if (SAUDI_VAT_REGEX.test(cleaned)) {
    return { status: 'format_valid', country: 'Saudi' };
  }

  return { status: 'format_invalid', country: null };
}
