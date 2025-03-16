import 'package:easy_localization/easy_localization.dart';
import 'package:event_planner/provider/auth_provider.dart';
import 'package:event_planner/provider/connectivity_provider.dart';
import 'package:event_planner/provider/home_provider.dart';
import 'package:event_planner/provider/nav_bar_provider.dart';
import 'package:event_planner/provider/post_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:event_planner/helper/route_helper.dart';
import 'package:event_planner/provider/localization_provider.dart';
import 'firebase_options.dart';
import 'package:sizer/sizer.dart';
import 'package:event_planner/data/base/di_container.dart' as di;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> main() async {
  Future<void> initializeLocalNotifications() async {
    // iOS (Darwin) initialization settings without onDidReceiveLocalNotification.
    final DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    // Android initialization settings.
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/launcher_icon');

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    // Initialize the plugin and provide a callback for notification responses.
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Handle the notification tap/click.
        print('Notification clicked, payload: ${response.payload}');
      },
    );
  }

  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    print('Foreground message received: ${message.notification?.title}');

    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your_channel_id',
      'Your Channel Name',
      channelDescription: 'Your channel description',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0, // notification id
      message.notification?.title,
      message.notification?.body,
      platformChannelSpecifics,
    );
  });

  RouteHelper.setupRouter();
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Initialize local notifications
  await initializeLocalNotifications();
  // Subscribe to the topic "allUsers"
  FirebaseMessaging.instance.subscribeToTopic("allUsers");
  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  await di.init();

  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => AuthenticationProvider(di.sl(), di.sl())),
        ChangeNotifierProvider(create: (ctx) => LocalizationProvider(sharedPreferences: di.sl())),
        ChangeNotifierProvider(create: (ctx) => NavBarProvider()),
        ChangeNotifierProvider(create: (ctx) => HomeProvider(homeRepository: di.sl())),
        ChangeNotifierProvider(create: (ctx) => PostProvider(postRepository: di.sl())),
        ChangeNotifierProvider(create: (ctx) => ConnectivityProvider()),
      ],
      child: EasyLocalization(
        supportedLocales: const [Locale('en', 'US'), Locale('si', 'LK')],
        path: 'assets/translations', // <-- change the path of the translation files
        fallbackLocale: const Locale('en', 'US'),
        child: MyApp(),
      ),
    ),
  );

  WidgetsBinding.instance.addObserver(LifecycleObserver());
}

class LifecycleObserver extends WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {}
}

class MyApp extends StatelessWidget {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  const MyApp({super.key});
  // Add a flag to track SnackBar visibility
  static bool isSnackBarVisible = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectivityProvider>(builder: (context, connectivityProvider, child) {
      return Sizer(builder: (context, orientation, deviceType) {
        return MaterialApp(
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          initialRoute: RouteHelper.splash,
          onGenerateRoute: RouteHelper.router.generator,
          debugShowCheckedModeBanner: false,
          navigatorKey: MyApp.navigatorKey,
          theme: ThemeData(scaffoldBackgroundColor: Colors.white, fontFamily: 'Poppins'),
        );
      });
    });
  }
}
