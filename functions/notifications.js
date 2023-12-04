const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

exports.checkNotifications = functions.pubsub
  .schedule("every 5 minutes")
  .timeZone("Canada/Newfoundland")
  .onRun(async (context) => {
    try {
      const usersSnapshot = await admin.firestore().collection("users").get();

      // Iterate through each user
      usersSnapshot.forEach(async (userDoc) => {
        const userId = userDoc.id;

        // Get the 'notifications' subcollection for the current user
        const notificationsRef = admin
          .firestore()
          .collection("users")
          .doc(userId)
          .collection("notifications");

        // Get all notifications
        const allNotifications = await notificationsRef.get();

        // Process all notifications
        allNotifications.forEach((notificationDoc) => {
          // Get the notification data
          const notificationData = notificationDoc.data();

          // Calculate the notification time based on the type
          let notificationTime;
          if (notificationData.type === "timeslot") {
            // Send notification half an hour before the timeslot
            notificationTime = notificationData.time - 30 * 60 * 1000;
          } else {
            // Send notification 12 hours before the deliverable
            notificationTime = notificationData.time - 12 * 60 * 60 * 1000;
          }

          // Check if it's time to send the notification
          if (new Date().getTime() >= notificationTime) {
            // Send a notification using Firebase Cloud Messaging (FCM)
            const message = {
              notification: {
                title:
                  notificationData.type === "timeslot"
                    ? "Class starting soon!"
                    : "Deliverable due soon!",
                body: `${notificationData.name} for ${
                  notificationData.courseName
                } is ${
                  notificationData.type === "timeslot" ? "starting" : "due"
                } soon!`,
              },
              token: userDoc.data().fcmToken,
              data: { type: notificationData.type }, // Assuming you have an 'fcmToken' field in your user document
            };

            // Send the message
            admin.messaging().send(message);
          }
        });
      });

      return null;
    } catch (error) {
      console.error("Error:", error);
      return null;
    }
  });
