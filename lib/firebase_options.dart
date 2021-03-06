// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars
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
    // ignore: missing_enum_constant_in_switch
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
    }

    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBiZmWb0Vljfg-PW7rlUJAQfvUgVFPV9-U',
    appId: '1:1055212968282:web:8235bea3dd12f9790fbb63',
    messagingSenderId: '1055212968282',
    projectId: 'food-delivery-7e243',
    authDomain: 'food-delivery-7e243.firebaseapp.com',
    storageBucket: 'food-delivery-7e243.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyArlvU76s2lOApk32kWbz_X_uAvFSA894Y',
    appId: '1:1055212968282:android:f485a55ec85e87020fbb63',
    messagingSenderId: '1055212968282',
    projectId: 'food-delivery-7e243',
    storageBucket: 'food-delivery-7e243.appspot.com',
  );
}
