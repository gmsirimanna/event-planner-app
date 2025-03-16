import 'dart:async';
import 'package:event_planner/main.dart';
import 'package:event_planner/provider/auth_provider.dart';
import 'package:event_planner/screens/navigation/nav_bar_screen.dart';
import 'package:event_planner/utils/alerts.dart';
import 'package:event_planner/utils/app_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:event_planner/helper/route_helper.dart';
import 'package:event_planner/screens/login/login_screen.dart';
import 'package:event_planner/utils/images.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkLoginStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Image.asset(
        Images.app_icon,
        width: 60,
        height: 60,
      )),
    );
  }

  /// Check login status and retrieve UUID
  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool(AppConstants.IS_LOGGED_IN) ?? false;
    String? userUUID = prefs.getString(AppConstants.UUID);

    Future.delayed(const Duration(milliseconds: 500), () async {
      if (isLoggedIn && userUUID != null) {
        Navigator.of(MyApp.navigatorKey.currentContext!)
            .pushNamedAndRemoveUntil(RouteHelper.navBar, (route) => false, arguments: NavBarScreen());
      } else {
        // Logout current user if they closed the ap before completing the user details, navigate back to login
        if (FirebaseAuth.instance.currentUser != null) FirebaseAuth.instance.signOut();
        Navigator.of(MyApp.navigatorKey.currentContext!)
            .pushNamedAndRemoveUntil(RouteHelper.login, (route) => false, arguments: LoginScreen());
      }
    });
  }
}
