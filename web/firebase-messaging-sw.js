importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-messaging.js");

const firebaseConfig = {
    apiKey: "AIzaSyBq1EL-w2lujfSo-HMs0RuOsLrV8DUwmu8",
    authDomain: "course-compass.firebaseapp.com",
    projectId: "course-compass",
    storageBucket: "course-compass.appspot.com",
    messagingSenderId: "725054805811",
    appId: "1:725054805811:web:de7dba3d9129302278d046"
  };

firebase.initializeApp(firebaseConfig);

const messaging = firebase.messaging();

// Optional:
messaging.onBackgroundMessage((message) => {
  console.log("onBackgroundMessage", message);
});
