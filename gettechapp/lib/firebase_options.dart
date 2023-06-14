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
        return ios;
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
    apiKey: 'AIzaSyAC7UYypUUvlYiZeXxafO-ugdThbOiMsQs',
    appId: '1:1070294711581:web:71d88960d37d7a30e6b5f4',
    messagingSenderId: '1070294711581',
    projectId: 'gettech-abf4c',
    authDomain: 'gettech-abf4c.firebaseapp.com',
    databaseURL: 'https://gettech-abf4c-default-rtdb.firebaseio.com',
    storageBucket: 'gettech-abf4c.appspot.com',
    measurementId: 'G-FKMQDXML64',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAuIryfjF4-Smg3EjQZ25BoqmHnEvn8VxI',
    appId: '1:1070294711581:android:ff17ef4f73edd33fe6b5f4',
    messagingSenderId: '1070294711581',
    projectId: 'gettech-abf4c',
    databaseURL: 'https://gettech-abf4c-default-rtdb.firebaseio.com',
    storageBucket: 'gettech-abf4c.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCIXdljwqwft7iXxCViLgbc5R5zCKqCOFc',
    appId: '1:1070294711581:ios:ba52e2c3ccb3c306e6b5f4',
    messagingSenderId: '1070294711581',
    projectId: 'gettech-abf4c',
    databaseURL: 'https://gettech-abf4c-default-rtdb.firebaseio.com',
    storageBucket: 'gettech-abf4c.appspot.com',
    iosClientId: '1070294711581-uhteectc7jhopp6v8hlt4p16n3j2oi52.apps.googleusercontent.com',
    iosBundleId: 'com.example.gettechapp',
  );
}
