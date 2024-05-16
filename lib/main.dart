import 'dart:async';

import 'package:customer_portal/splash/splashScreen.dart';
import 'package:customer_portal/viewModels/notification_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:provider/provider.dart';

import 'firebase/firebase.dart';
import 'firebase/remoteConfig.dart';
import 'home/homePage.dart';

const _myLogFileName = "MyLogFile"; // Declare _myLogFileName
const _tag = "YourTag"; // Declare _tag
var logStatus = '';
final _completer = Completer<String>(); // Declare _completer

void configureNotificationChannel() async {
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'channel_id', // Replace with your channel ID
    'Channel Name', // Replace with your channel name
    // 'Channel Description', // Replace with your channel description
    importance: Importance.high,
  );
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
}

Future<void> initLogs() async {
  await FlutterLogs.initLogs(
      logLevelsEnabled: [
        LogLevel.INFO,
        LogLevel.WARNING,
        LogLevel.ERROR,
        LogLevel.SEVERE,
      ],
      timeStampFormat: TimeStampFormat.TIME_FORMAT_READABLE,
      directoryStructure: DirectoryStructure.FOR_DATE,
      logTypesEnabled: [_myLogFileName],
      logFileExtension: LogFileExtension.LOG,
      logsWriteDirectoryName: "MyLogs",
      logsExportDirectoryName: "MyLogs/Exported",
      debugFileOperations: true,
      isDebuggable: true);

  // [IMPORTANT] The first log line must never be called before 'FlutterLogs.initLogs'
  FlutterLogs.logInfo(_tag, "setUpLogs", "Setting up logs..");

  // Logs Exported Callback
  FlutterLogs.channel.setMethodCallHandler((call) async {
    if (call.method == 'logsExported') {
      // Contains file name of zip
      FlutterLogs.logInfo(
          _tag, "setUpLogs", "logsExported: ${call.arguments.toString()}");

      setLogsStatus(
          status: "logsExported: ${call.arguments.toString()}", append: true);

      // Notify Future with value
      _completer.complete(call.arguments.toString());
    } else if (call.method == 'logsPrinted') {
      FlutterLogs.logInfo(
          _tag, "setUpLogs", "logsPrinted: ${call.arguments.toString()}");

      setLogsStatus(
          status: "logsPrinted: ${call.arguments.toString()}", append: true);
    }
  });
}

void setLogsStatus({String status = '', bool append = false}) {
  logStatus = status;
}

void setUserInformation(String username, String userId) {
  print("setUserInformation---");
  FirebaseCrashlytics.instance.setCustomKey('username', username);
  FirebaseCrashlytics.instance.setCustomKey('userId', userId);
}

void main() async {

  debugProfileBuildsEnabled = true;
  WidgetsFlutterBinding.ensureInitialized();
  initLogs(); // Use initLogs directly without FlutterLogs prefix
  configureNotificationChannel();

  await Firebase.initializeApp();
  await FireBaseApi().initNotifications();

  final remoteConfigService = RemoteConfigService();
  await remoteConfigService.initialize();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Enable Crashlytics in release builds
  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  setUserInformation('Jissa', '0001');
  // SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop', true);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NotificationDataProvider()),
        // Add other providers if needed
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Call configureFirebase within the widget tree
    configureFirebase(context);

    return MaterialApp(
      title: 'Login API App',
      home: SplashScreen(),
    );
  }
}


void configureFirebase(BuildContext context) async {
  print('configureFirebase');
  final RemoteMessage? initialMessage =
      await FirebaseMessaging.instance.getInitialMessage();
  print('configureFirebase--initialMessage$initialMessage');

  if (initialMessage != null) {
    print('initialMessage from a message: $initialMessage');
    print("initialMessage from a message2: ${initialMessage.data}");
    final notificationData = initialMessage.data;
    print("notificationData-initialMessage: ${notificationData}");

    Provider.of<NotificationDataProvider>(context, listen: false)
        .setNotificationData(NotificationData(notificationData));
  }

  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    print('configureFirebase1');

    print('Received a message: $message');

    // Access specific data fields:
    final notificationTitle = message.notification?.title;
    final notificationBody = message.notification?.body;
    final customData = message.data; // Access custom data

    // Handle the message when the app is in the foreground.
    // You can use the data you've extracted in your UI or for other actions.
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
    print('configureFirebase2');

    print('App opened from a message: $message');
    print("App opened from a message2: ${message.data}");
    final notificationData = message.data;
    print("notificationData: ${notificationData}");

    Provider.of<NotificationDataProvider>(context, listen: false)
        .setNotificationData(NotificationData(notificationData));

    // Access specific data fields and custom data as needed.
    // Handle the message when the app is in the background and opened from the notification.
  });
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('configureFirebase3');
  print("Handling a background message: ${message}");

  print("Handling a background message1: ${message.messageId}");
  print("Handling a background message2: ${message.data}");

  // Handle the message when the app is terminated but still receives a message.
}
//   return MaterialApp(
//     title: 'Splash Screen',
//     theme: ThemeData(
//       primarySwatch: Colors.green,
//     ),
//     home: SplashScreen(),
//     debugShowCheckedModeBanner: true,
//     // routes: {
//     //   // CustomerPortalRoutes.home: (context) => HomePage(),
//     //   CustomerPortalRoutes.outstanding: (context) => Outstanding(),
//     //   CustomerPortalRoutes.sales: (context) => SalesList(),
//     //   CustomerPortalRoutes.custodyDetails: (context) => CustodyDetails(),
//     //   CustomerPortalRoutes.couponBook: (context) => CouponListPage(),
//     //   CustomerPortalRoutes.profile: (context) => ProfileScreen(),
//     //   CustomerPortalRoutes.register: (context) => RegisterScreen(),
//     //   CustomerPortalRoutes.contacts: (context) => ContactUs(),
//     //   CustomerPortalRoutes.settings: (context) => Setting(),
//     //
//     //   CustomerPortalRoutes.login: (context) => LoginScreen(),
//     //   // CustomerPortalRoutes.forgotPassword: (context) => ForgotPasswordPage(),
//     // },
//   );
// }

// return MaterialApp(
//   title: 'Splash Screen',
//   theme: ThemeData(
//     primarySwatch: Colors.green,
//   ),
//   home: Consumer<NotificationDataProvider>(
//     builder: (context, notificationProvider, _) {
//       print('notificationProvider--${notificationProvider.notificationData.data}');
//       return SplashScreen();
//     },
//   ),
//   debugShowCheckedModeBanner: true,
// );
// return ChangeNotifierProvider(
//   create: (_) => RegisterProvider(),
//   child: MaterialApp(
//     title: 'Login API App',
//     home: SplashScreen(),
//
//   ),
// );