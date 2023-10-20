importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-messaging.js");

firebase.initializeApp({
    apiKey: "AIzaSyBM8woCtycdBxjLsha6sDdtyh03bigJzMs",
    authDomain: "managercoffeeandfood.firebaseapp.com",
    projectId: "managercoffeeandfood",
    storageBucket: "managercoffeeandfood.appspot.com",
    messagingSenderId: "204912491565",
    appId: "1:204912491565:web:43f0347c5bc699e331cca4",
    measurementId: "G-718BNZ61C3"
});

const messaging = firebase.messaging();
// const supported = await isSupported()
// if (!supported) {
//     throw new Error(NOTIFICATIONS_NOT_SUPPORTED)
// }
const vapidKey = 'BEeyGbXI0y0HJLcWZ5jDqDi_FClLQ7BNgfEHcBVz7kOd6P3Z9iUD7n9SKPd6IfH7DIyCt3mfnd4kauqOH-mgBhQ'
// const messaging = getMessaging();
const messagingToken = await getToken(messaging, { vapidKey })

// Optional:
messaging.onBackgroundMessage((message) => {
    console.log("onBackgroundMessage", message);
});