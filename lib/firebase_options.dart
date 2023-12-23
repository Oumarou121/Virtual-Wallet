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
      apiKey: "AIzaSyCq8aO67UaO79T3kmP-8te7DQmOEclejuc",
      authDomain: "my-virtual-wallet-5f4d7.firebaseapp.com",
      projectId: "my-virtual-wallet-5f4d7",
      storageBucket: "my-virtual-wallet-5f4d7.appspot.com",
      messagingSenderId: "793314480218",
      appId: "1:793314480218:web:1412f4b9496da62f8c8863",
      measurementId: "G-BLJBC7JGVW");

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCIcCCJ7OZ_YM2o2Supdc_VNN_ezzVl1MI',
    appId: '1:793314480218:android:054cbd7342e6587e8c8863',
    messagingSenderId: '793314480218',
    projectId: 'my-virtual-wallet-5f4d7',
    databaseURL: 'https://my-virtual-wallet-5f4d7-default-rtdb.firebaseio.com',
    storageBucket: 'my-virtual-wallet-5f4d7.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDEmq_cAowrxRbOQ1ti4pQBK_yEum7AF-w',
    appId: '1:793314480218:ios:9207a9d392b835a68c8863',
    messagingSenderId: '793314480218',
    projectId: 'my-virtual-wallet-5f4d7',
    databaseURL: 'https://my-virtual-wallet-5f4d7-default-rtdb.firebaseio.com',
    storageBucket: 'my-virtual-wallet-5f4d7.appspot.com',
    androidClientId:
        '793314480218-fpg49psq81ejvd2br92s04hd46dv2o35.apps.googleusercontent.com',
    iosBundleId: 'com.scorpion.virtualwallet2',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDEmq_cAowrxRbOQ1ti4pQBK_yEum7AF-w',
    appId: '1:793314480218:ios:9207a9d392b835a68c8863',
    messagingSenderId: '793314480218',
    projectId: 'my-virtual-wallet-5f4d7',
    databaseURL: 'https://my-virtual-wallet-5f4d7-default-rtdb.firebaseio.com',
    storageBucket: 'my-virtual-wallet-5f4d7.appspot.com',
    androidClientId:
        '793314480218-fpg49psq81ejvd2br92s04hd46dv2o35.apps.googleusercontent.com',
    iosBundleId: 'com.example.virtual_wallet_2',
  );
}
