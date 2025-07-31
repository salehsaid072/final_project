import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDnfT_fn_JruUA5J5S8ZMCnu9v6XXyQ6bE',
    authDomain: 'agrimarkethub-613a4.firebaseapp.com',
    projectId: 'agrimarkethub-613a4',
    storageBucket: 'agrimarkethub-613a4.firebasestorage.app',
    messagingSenderId: '65250963002',
    appId: '1:65250963002:web:b76eb9dfe80999112b8f03',
    measurementId: 'G-ZQD9Q0DBQ3',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBkzHxfQ_esGv1N4PiCVFtiZ9kAxl8A-Ww',
    appId: '1:65250963002:android:05c54df372b7493b2b8f03',
    messagingSenderId: '65250963002',
    projectId: 'agrimarkethub-613a4',
    storageBucket: 'agrimarkethub-613a4.firebasestorage.app',
    iosClientId: '1:65250963002:ios:05c54df372b7493b2b8f03',
    androidClientId: '1:65250963002:android:05c54df372b7493b2b8f03',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBkzHxfQ_esGv1N4PiCVFtiZ9kAxl8A-Ww',
    appId: '1:65250963002:ios:05c54df372b7493b2b8f03',
    messagingSenderId: '65250963002',
    projectId: 'agrimarkethub-613a4',
    storageBucket: 'agrimarkethub-613a4.firebasestorage.app',
    iosClientId: '1:65250963002:ios:05c54df372b7493b2b8f03',
    iosBundleId: 'com.example.agrimarkethub',
  );
}
