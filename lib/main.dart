import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:event_planner/helper/route_helper.dart';
import 'package:event_planner/provider/localization_provider.dart';
import 'package:event_planner/provider/splash_provider.dart';

import 'package:sizer/sizer.dart';
import 'package:event_planner/data/base/di_container.dart' as di;

Future<void> main() async {
  RouteHelper.setupRouter();
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  final sharedPreferences = await SharedPreferences.getInstance();
  //register dio client and other providers
  await di.init();

  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => SplashProvider()),
        ChangeNotifierProvider(create: (ctx) => LocalizationProvider(sharedPreferences: sharedPreferences)),
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
  static final navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
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
  }
}
