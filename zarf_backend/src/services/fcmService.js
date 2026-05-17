import admin from 'firebase-admin';
import env from '../config/env.js';

let initialized = false;

const ensureInitialized = () => {
  if (initialized) return true;
  try {
    if (!admin.apps.length) {
      admin.initializeApp({
        credential: admin.credential.cert({
          projectId: env.FIREBASE_PROJECT_ID,
          clientEmail: env.FIREBASE_CLIENT_EMAIL,
          privateKey: env.FIREBASE_PRIVATE_KEY.replace(/\\n/g, '\n')
        })
      });
    }
    initialized = true;
    return true;
  } catch (error) {
    console.warn('FCM initialization failed:', error.message);
    return false;
  }
};

export const sendNotification = async (fcmToken, title, body) => {
  if (!ensureInitialized()) {
    return;
  }

  if (!fcmToken) {
    console.warn('FCM token missing. Skipping push notification.');
    return;
  }

  try {
    await admin.messaging().send({
      token: fcmToken,
      notification: { title, body }
    });
  } catch (error) {
    console.warn('FCM send failed:', error.message);
  }
};
