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
    apiKey: 'AIzaSyBQWSxtCOsuHQ8S3JZonbH-cqCTQgXdwbY',
    appId: '1:454516970739:web:0e5cc14f0162c174d79386',
    messagingSenderId: '454516970739',
    projectId: 'generatedevis',
    authDomain: 'generatedevis.firebaseapp.com',
    storageBucket: 'generatedevis.appspot.com',
    measurementId: 'G-HMRKRN5YZR',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDRkC7njo1mlIfqmQMFB_xq_rzCqkTWMD4',
    appId: '1:454516970739:android:ffe555cbd290d28ad79386',
    messagingSenderId: '454516970739',
    projectId: 'generatedevis',
    storageBucket: 'generatedevis.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDCP7i1-gHk6U6WH8olAQ8TvDlPqh05xYQ',
    appId: '1:454516970739:ios:1948b5d9d5680ae0d79386',
    messagingSenderId: '454516970739',
    projectId: 'generatedevis',
    storageBucket: 'generatedevis.appspot.com',
    iosClientId: '454516970739-t9bb9sl17mu94krrancju30h798dn0pl.apps.googleusercontent.com',
    iosBundleId: 'com.example.calculdevis',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDCP7i1-gHk6U6WH8olAQ8TvDlPqh05xYQ',
    appId: '1:454516970739:ios:2cf450da51c5d1acd79386',
    messagingSenderId: '454516970739',
    projectId: 'generatedevis',
    storageBucket: 'generatedevis.appspot.com',
    iosClientId: '454516970739-4ubjpg7r7r16oadah987o4vpl0eg5fot.apps.googleusercontent.com',
    iosBundleId: 'com.example.calculdevis.RunnerTests',
  );
}
