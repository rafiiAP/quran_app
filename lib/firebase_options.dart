import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class FirebaseConfig {
  static String get androidApiKey =>
      dotenv.env['ANDROID_FIREBASE_API_KEY'] ?? '';
  static String get iosApiKey => dotenv.env['IOS_FIREBASE_API_KEY'] ?? '';
}

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (Platform.isIOS) {
      return ios;
    } else {
      return android;
    }
  }

  static final FirebaseOptions android = FirebaseOptions(
    apiKey: FirebaseConfig.androidApiKey,
    appId: '1:839807394287:android:72d1d1588995865f4b161a',
    messagingSenderId: '839807394287',
    projectId: 'quran-app-877c6',
    storageBucket: 'quran-app-877c6.firebasestorage.app',
  );

  static final FirebaseOptions ios = FirebaseOptions(
    apiKey: FirebaseConfig.iosApiKey,
    appId: '1:839807394287:ios:28e585fe67d50d8f4b161a',
    messagingSenderId: '839807394287',
    projectId: 'quran-app-877c6',
    storageBucket: 'quran-app-877c6.firebasestorage.app',
    iosBundleId: 'com.raf.quranApp',
  );
}
