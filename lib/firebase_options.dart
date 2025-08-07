
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
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
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDS_HC40Nd-MvF2nBVb672Wqk1QnViplgA',
    appId: '1:1028801641342:web:fb460ff63445f24959d12f',
    messagingSenderId: '1028801641342',
    projectId: 'costeo-smart',
    authDomain: 'costeo-smart.firebaseapp.com',
    storageBucket: 'costeo-smart.firebasestorage.app',
    measurementId: 'G-Z48NCSBXQZ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCOIZDL_5PYTvn8z4Q6NHg-IG9dzIryWzM',
    appId: '1:1028801641342:android:d76259ac9961889f59d12f',
    messagingSenderId: '1028801641342',
    projectId: 'costeo-smart',
    storageBucket: 'costeo-smart.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBc_dJSGOiOBCCEF-szsGiMnSEn8XYeGx4',
    appId: '1:1028801641342:ios:c5593d270ed777d859d12f',
    messagingSenderId: '1028801641342',
    projectId: 'costeo-smart',
    storageBucket: 'costeo-smart.firebasestorage.app',
    iosBundleId: 'com.example.costeosmart',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBc_dJSGOiOBCCEF-szsGiMnSEn8XYeGx4',
    appId: '1:1028801641342:ios:c5593d270ed777d859d12f',
    messagingSenderId: '1028801641342',
    projectId: 'costeo-smart',
    storageBucket: 'costeo-smart.firebasestorage.app',
    iosBundleId: 'com.example.costeosmart',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDS_HC40Nd-MvF2nBVb672Wqk1QnViplgA',
    appId: '1:1028801641342:web:b09fe5cadbdafdd559d12f',
    messagingSenderId: '1028801641342',
    projectId: 'costeo-smart',
    authDomain: 'costeo-smart.firebaseapp.com',
    storageBucket: 'costeo-smart.firebasestorage.app',
    measurementId: 'G-NTT7BEDGF1',
  );
}
