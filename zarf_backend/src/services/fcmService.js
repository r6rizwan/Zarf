import admin from 'firebase-admin';
import env from '../config/env.js';

let initialized = false;

const ensureInitialized = () => {
  if (initialized) return true;
  try {
    if (!admin.apps.length) {
      admin.initializeApp();
    }
    initialized = true;
    return true;
  } catch (error) {
    console.warn('FCM initialization failed:', error.message);
    return false;
  }
};

export const sendNotification = async (fcmToken, title, body) => {
  if (!env.FCM_SERVER_KEY) {
    console.warn('FCM_SERVER_KEY missing. Skipping push notification.');
    return;
  }

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
