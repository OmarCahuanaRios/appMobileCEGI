// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyD6IyDQIEParxsnWHT8C-gsbJJWglpsvk0',
    appId: '1:65740183129:web:4291352099c9a9050c4348',
    messagingSenderId: '65740183129',
    projectId: 'zox-receptions',
    authDomain: 'zox-receptions.firebaseapp.com',
    storageBucket: 'zox-receptions.appspot.com',
    measurementId: 'G-41E04ZLKC9',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAaWcEUXXlwqhcdThOH25j3EwbPy2DlZq0',
    appId: '1:65740183129:android:0a7cc223c6a2f4e00c4348',
    messagingSenderId: '65740183129',
    projectId: 'zox-receptions',
    storageBucket: 'zox-receptions.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyARxnyflEG4nOYhV51fgQbrTeVnCA07Dds',
    appId: '1:65740183129:ios:0b92120978203d090c4348',
    messagingSenderId: '65740183129',
    projectId: 'zox-receptions',
    storageBucket: 'zox-receptions.appspot.com',
    iosBundleId: 'com.example.mobileReceptions',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyARxnyflEG4nOYhV51fgQbrTeVnCA07Dds',
    appId: '1:65740183129:ios:4554b485edf9092a0c4348',
    messagingSenderId: '65740183129',
    projectId: 'zox-receptions',
    storageBucket: 'zox-receptions.appspot.com',
    iosBundleId: 'com.example.mobileReceptions.RunnerTests',
  );
}