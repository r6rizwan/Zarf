import Groq from 'groq-sdk';
import env from '../config/env.js';

const groq = new Groq({ apiKey: env.GROQ_API_KEY });

const extractionPrompt =
  'Extract the following fields from this receipt image and return ONLY a JSON object with no markdown or explanation: { merchant: string, amount: number, currency: string (3-letter ISO), date: string (YYYY-MM-DD) } If a field cannot be determined, set it to null.';

const parseAndValidate = (rawText) => {
  let parsed;
  try {
    parsed = JSON.parse(rawText);
  } catch {
    throw new Error('Groq response was not valid JSON');
  }

  const normalized = {
    merchant: parsed.merchant ?? null,
    amount: parsed.amount ?? null,
    currency: parsed.currency ?? null,
    date: parsed.date ?? null
  };

  const validTypes =
    (normalized.merchant === null || typeof normalized.merchant === 'string') &&
    (normalized.amount === null || typeof normalized.amount === 'number') &&
    (normalized.currency === null || typeof normalized.currency === 'string') &&
    (normalized.date === null || typeof normalized.date === 'string');

  if (!validTypes) {
    throw new Error('Groq response had invalid field types');
  }

  return normalized;
};

export const parseReceipt = async ({ imageBuffer, mimetype }) => {
  const base64 = imageBuffer.toString('base64');
  const dataUrl = `data:${mimetype};base64,${base64}`;

  const completion = await groq.chat.completions.create({
    model: 'llama-3.2-11b-vision-preview',
    temperature: 0,
    messages: [
      { role: 'user', content: [
        { type: 'text', text: extractionPrompt },
        { type: 'image_url', image_url: { url: dataUrl } }
      ] }
    ]
  });

  const text = completion.choices?.[0]?.message?.content;
  if (!text || typeof text !== 'string') {
    throw new Error('Groq returned an empty response');
  }

  return parseAndValidate(text.trim());
};
