import 'package:customer_portal/constant/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FireBaseApi {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  late SharedPreferences _prefs;

  FireBaseApi() {
    _initializeSharedPreferences(); // Initialize SharedPreferences
  }

  Future<void> initNotifications() async {
    await _initializeSharedPreferences(); // Ensure SharedPreferences is initialized

    // Check if FCM token exists in SharedPreferences
    String? savedToken = _prefs.getString(Constants.FCM_TOKEN);
    bool? isFirstTime = _prefs.getBool(Constants.ISFIRST_FCM_TOKEN);
    print('FCM Token isFirstTime: $isFirstTime');
    if (savedToken != null) {
      print('FCM Token exists: $savedToken');
      await _prefs.setBool(Constants.ISFIRST_FCM_TOKEN, false);
    } else {
      // If token doesn't exist, request permission and get the FCM token
      NotificationSettings settings = await _firebaseMessaging.requestPermission();
      print('authorizationStatus-${settings.authorizationStatus}');
      print('authorized --${AuthorizationStatus.authorized}');
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        print('if authorizationStatus');
        final fcmToken = await _firebaseMessaging.getToken();
        print('New FCM Token generated: $fcmToken');
        // Save the token to SharedPreferences
        await _prefs.setString(Constants.FCM_TOKEN, fcmToken!);
        await _prefs.setBool(Constants.ISFIRST_FCM_TOKEN, true);
      } else {
        print('else authorizationStatus');
      }
    }
  }


  Future<void> _initializeSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }
}

