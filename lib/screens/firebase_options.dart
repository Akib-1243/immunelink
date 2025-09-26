import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDO8pYwjWxiN8v8iSErC6ZXmqI-J_2qX50',
    appId: '1:689155262672:android:77964f5196f87660f636d5',
    messagingSenderId: '689155262672',
    projectId: 'immunelink-b4c2b',
    databaseURL: 'https://immunelink-b4c2b-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'immunelink-b4c2b.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCMAZueew4Fm74KxBpbQk1ExpS_HlORiYo',
    appId: '1:689155262672:ios:7000528099138103f636d5',
    messagingSenderId: '689155262672',
    projectId: 'immunelink-b4c2b',
    databaseURL: 'https://immunelink-b4c2b-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'immunelink-b4c2b.firebasestorage.app',
    iosBundleId: 'com.example.immunelink',
  );
}
