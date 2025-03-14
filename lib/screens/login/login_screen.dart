import 'package:easy_localization/easy_localization.dart';
import 'package:event_planner/data/repository/exception/api_error_handler.dart';
import 'package:event_planner/main.dart';
import 'package:event_planner/provider/nav_bar_provider.dart';
import 'package:event_planner/screens/navigation/nav_bar_screen.dart';
import 'package:event_planner/utils/app_constants.dart';
import 'package:event_planner/utils/color_resources.dart';
import 'package:event_planner/utils/styles.dart';
import 'package:event_planner/utils/alerts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../helper/route_helper.dart';
import '../../provider/auth_provider.dart';
import '../../resuable_widgets/custom_button.dart';
import '../../resuable_widgets/custom_text_field.dart';
import '../../utils/validator.dart';
import 'restore_pass_screen.dart';
import 'signup_screen.dart';
import 'welcome_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthenticationProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: PopupMenuButton<Locale>(
                  onSelected: (Locale locale) {
                    context.setLocale(locale);
                  },
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<Locale>>[
                    const PopupMenuItem<Locale>(value: Locale('en', 'US'), child: Text('English')),
                    const PopupMenuItem<Locale>(value: Locale('si', 'LK'), child: Text('සිංහල')),
                  ],
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.public, color: Colors.black),
                        const SizedBox(width: 6),
                        Text(
                          context.locale.languageCode == "en" ? "En" : "සිං",
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Text('welcome'.tr(),
                  style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center),
              const SizedBox(height: 8),
              Text(tr("welcome_portal"),
                  style: const TextStyle(fontSize: 16, color: Colors.black), textAlign: TextAlign.center),
              const SizedBox(height: 40),
              CustomTextField(
                controller: emailController,
                labelText: tr("email"),
                hintText: tr("email_hint"),
                isShowPrefixIcon: true,
                prefixIconUrl: const Icon(Icons.email_outlined),
                validator: Validators.validateEmail,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: passwordController,
                labelText: tr("password"),
                hintText: tr("password_hint"),
                isPassword: true,
                isShowPrefixIcon: true,
                isShowSuffixIcon: true,
                prefixIconUrl: const Icon(Icons.lock_outline),
                validator: Validators.validatePassword,
              ),
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context)
                        .pushNamed(RouteHelper.restorePass, arguments: RestorePasswordScreen());
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        tr('restore_password'),
                        style: poppinsMedium.copyWith(
                          color: ColorResources.primaryColor, // Adjust to your color
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.north_east, // or Icons.arrow_outward, etc.
                        color: ColorResources.primaryColor,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.width * 0.3),
              if (authProvider.errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(
                    authProvider.errorMessage!,
                    style: const TextStyle(color: Colors.red, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ),
              const SizedBox(height: 16),
              CustomButton(
                buttonText: 'login'.tr(),
                icon: Icons.arrow_forward,
                isLoading: authProvider.isLoading,
                backgroundColor: authProvider.isLoading ? Colors.grey : ColorResources.primaryColor,
                onPressed: () => handleLogin(authProvider, emailController.text, passwordController.text),
              ),
              const SizedBox(height: 16),
              CustomButton(
                buttonText: 'sign_up'.tr(),
                icon: Icons.arrow_forward,
                onPressed: () {
                  Navigator.of(context).pushNamed(RouteHelper.signup, arguments: SignUpScreen());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void handleLogin(AuthenticationProvider authProvider, String username, String password) {
    // Validate username (email in this case)
    String? usernameError = Validators.validateEmail(username);
    if (usernameError != null) {
      customSnackBar(AppConstants.invalidEmail, Colors.red);
      return; // Stop login process
    }

    // Validate password
    String? passwordError = Validators.validatePassword(password.trim());
    if (passwordError != null) {
      customSnackBar(AppConstants.invalidPassword, Colors.red);
      return; // Stop login process
    }

    // Proceed with login if validations pass
    authProvider.signIn(username.trim(), password.trim()).then((_) async {
      if (authProvider.user != null) {
        final navBarProvider = Provider.of<NavBarProvider>(context, listen: false);
        navBarProvider.setNavBarIndex(0);

        // Keep a flag for login again
        bool isAvailable = await authProvider.saveUserData();

        if (!isAvailable) {
          Navigator.of(MyApp.navigatorKey.currentContext!)
              .pushNamedAndRemoveUntil(RouteHelper.welcome, (route) => false, arguments: WelcomeScreen());
        } else {
          Navigator.of(MyApp.navigatorKey.currentContext!)
              .pushNamedAndRemoveUntil(RouteHelper.navBar, (route) => false, arguments: NavBarScreen());
        }
      } else {
        customSnackBar(AppConstants.userNotFound, Colors.red);
      }
    }).catchError((error) {
      customSnackBar(ApiErrorHandler.getMessage(error), Colors.red);
    });
  }
}
