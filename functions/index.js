const functions = require("firebase-functions");
const admin = require("firebase-admin");

// Initialize the Admin SDK
admin.initializeApp();

/**
 * Firestore Trigger: Send Welcome Notification on New User
 */
exports.sendWelcomeNotification = functions.firestore
  .document("users/{userId}")
  .onCreate(async (snap, context) => {
    let userData = snap.data();

    // If no fcmToken on creation, wait 5 seconds and try again.
    if (!userData || !userData.fcmToken) {
      console.log("No FCM token at creation, waiting 5 seconds for update...");
      await new Promise((resolve) => setTimeout(resolve, 2000));
      const docSnap = await admin
        .firestore()
        .collection("users")
        .doc(context.params.userId)
        .get();
      userData = docSnap.data();
      if (!userData || !userData.fcmToken) {
        console.log("Still no FCM token , skipping welcome notification.");
        return null;
      }
    }

    const message = {
      token: userData.fcmToken,
      notification: {
        title: `🎉 Welcome to Event Planner ${userData.firstName}!`,
        body: "Thank you for joining! Explore events with ease!",
      },
    };

    try {
      const response = await admin.messaging().send(message);
      console.log("Welcome notification sent:", response);
    } catch (error) {
      console.error("Error sending welcome notification:", error);
    }
    return null;
  });

/**
 * Firestore Trigger: Send "Welcome Back" Notification on User Profile Update
 */
exports.sendProfileUpdateNotification = functions.firestore
  .document("users/{userId}")
  .onUpdate(async (change) => {
    const beforeData = change.before.data();
    const afterData = change.after.data();
    if (!afterData || !afterData.fcmToken) {
      console.log("No FCM token found, skipping profile update notification.");
      return null;
    }

    // Check if relevant fields changed
    const fieldsChanged =
      beforeData.firstName !== afterData.firstName ||
      beforeData.lastName !== afterData.lastName ||
      beforeData.email !== afterData.email ||
      beforeData.phoneNumber !== afterData.phoneNumber ||
      beforeData.mailingAddress !== afterData.mailingAddress ||
      beforeData.profileImageUrl !== afterData.profileImageUrl;

    if (!fieldsChanged) {
      console.log("No relevant profile changes Skipping notification.");
      return null;
    }

    // Send "Welcome Back" notification
    const message = {
      token: afterData.fcmToken,
      notification: {
        title: `📅 Profile Updated!`,
        body: "Your changes have been successfully",
      },
    };

    try {
      const response = await admin.messaging().send(message);
      console.log("Profile update notification sent:", response);
    } catch (error) {
      console.error("Error sending profile update notification:", error);
    }
    return null;
  });

/**
 * Scheduled Functions: Three Push Notifications Daily
 *
 * NOTE: This requires the Blaze plan (pay-as-you-go) and
 * the Cloud Scheduler + Pub/Sub APIs enabled.
 */

// 8 AM (UTC)
exports.scheduledNotification8AM = functions.pubsub
  .schedule("0 8 * * *")
  .timeZone("UTC")
  .onRun(async () => {
    const message = {
      notification: {
        title: "Good Morning!",
        body: "It's 8 AM UTC. Have a great day!",
      },
      topic: "allUsers", // All users must subscribe to this topic
    };

    try {
      const response = await admin.messaging().send(message);
      console.log("8 AM Notification sent:", response);
    } catch (error) {
      console.error("Error sending 8 AM Notification:", error);
    }
    return null;
  });

// 12 PM (UTC)
exports.scheduledNotification12PM = functions.pubsub
  .schedule("0 12 * * *")
  .timeZone("UTC")
  .onRun(async () => {
    const message = {
      notification: {
        title: "Lunch Reminder",
        body: "It's 12 PM UTC. Time for a break!",
      },
      topic: "allUsers",
    };

    try {
      const response = await admin.messaging().send(message);
      console.log("12 PM Notification sent:", response);
    } catch (error) {
      console.error("Error sending 12 PM Notification:", error);
    }
    return null;
  });

// 5 PM (UTC)
exports.scheduledNotification5PM = functions.pubsub
  .schedule("0 17 * * *")
  .timeZone("UTC")
  .onRun(async () => {
    const message = {
      notification: {
        title: "Evening Check-In",
        body: "It's 5 PM UTC. How was your day?",
      },
      topic: "allUsers",
    };

    try {
      const response = await admin.messaging().send(message);
      console.log("5 PM Notification sent:", response);
    } catch (error) {
      console.error("Error sending 5 PM Notification:", error);
    }
    return null;
  });
