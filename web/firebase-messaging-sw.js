importScripts('https://www.gstatic.com/firebasejs/8.10.0/firebase-app.js');
importScripts('https://www.gstatic.com/firebasejs/8.10.0/firebase-messaging.js');

const firebaseConfig = {
    apiKey: 'AIzaSyAGYI3TWJyOGBEIsMTfhY8BukheE9U-E-8',
    appId: '1:419473345657:web:cecaa9b6537374579f58a8',
    messagingSenderId: '419473345657',
    projectId: 'efv-app-256d4',
    storageBucket: 'efv-app-256d4.firebasestorage.app',
    iosBundleId: 'com.br.spotecnologia.efvapp',
};

firebase.initializeApp(firebaseConfig);

const messaging = firebase.messaging();

messaging.onBackgroundMessage((payload) => {
    console.log('[firebase-messaging-sw.js] Received background message ', payload);
    const notificationTitle = 'Background Message Title';
    const notificationOptions = {
        body: payload.data.message || 'Background Message Body.',
        icon: '/favicon.png'
    };

    return self.registration.showNotification(notificationTitle, notificationOptions);
});