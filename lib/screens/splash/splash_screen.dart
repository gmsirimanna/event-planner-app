import 'dart:async';
import 'package:event_planner/screens/login/welcome_screen.dart';
import 'package:event_planner/screens/navigation/nav_bar_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:event_planner/helper/route_helper.dart';
import 'package:event_planner/screens/login/login_screen.dart';
import 'package:event_planner/utils/images.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late SharedPreferences _prefs;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initPrefs();
    });
  }

  initPrefs() async {
    Future.delayed(const Duration(seconds: 1), () => _route());
  }

  void _route() {
    Navigator.of(context)
        // .pushNamedAndRemoveUntil(RouteHelper.welcome, (route) => false, arguments: WelcomeScreen());
        .pushNamedAndRemoveUntil(RouteHelper.navBar, (route) => false, arguments: NavBarScreen());
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
}
