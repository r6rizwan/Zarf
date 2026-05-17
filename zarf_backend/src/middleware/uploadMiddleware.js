import fs from 'fs/promises';
import multer from 'multer';

const allowedMimeTypes = new Set(['image/jpeg', 'image/png', 'image/webp']);

const upload = multer({
  dest: './uploads/',
  limits: { fileSize: 5 * 1024 * 1024 },
  fileFilter: (req, file, cb) => {
    if (!allowedMimeTypes.has(file.mimetype)) {
      cb(new Error('Only jpeg, png, and webp images are allowed'));
      return;
    }
    cb(null, true);
  }
});

export const uploadMiddleware = upload.single('receipt');

export const cleanupTempFile = async (filePath) => {
  if (!filePath) return;
  try {
    await fs.unlink(filePath);
  } catch (_) {
    // ignore cleanup errors
  }
};
