import 'package:easy_localization/easy_localization.dart';
import 'package:event_planner/screens/login/restore_pass_screen.dart';
import 'package:event_planner/screens/login/signup_screen.dart';
import 'package:event_planner/screens/login/welcome_screen.dart';
import 'package:event_planner/utils/color_resources.dart';
import 'package:event_planner/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../helper/route_helper.dart';
import '../../resuable_widgets/custom_button.dart';
import '../../resuable_widgets/custom_text_field.dart';
import '../../utils/validator.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      // SafeArea helps avoid overlapping with the status bar
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Language Selector Row
              Align(
                alignment: Alignment.centerRight,
                child: PopupMenuButton<Locale>(
                  onSelected: (Locale locale) {
                    context.setLocale(locale);
                  },
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<Locale>>[
                    const PopupMenuItem<Locale>(
                      value: Locale('en', 'US'),
                      child: Text('English'),
                    ),
                    const PopupMenuItem<Locale>(
                      value: Locale('si', 'LK'),
                      child: Text('සිංහල'),
                    ),
                  ],
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: ColorResources.secondaryFillColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.public, color: Colors.black), // World icon
                        const SizedBox(width: 6),
                        Text(
                          context.locale.languageCode == "en" ? "En" : "සිං", // Show EN or SI dynamically
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Top spacing
              const SizedBox(height: 40),

              // Welcome title
              Text(
                'welcome'.tr(),
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                tr("welcome_portal"),
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 40),

              // Email TextField
              CustomTextField(
                  labelText: tr("email"),
                  hintText: tr("email_hint"),
                  isShowPrefixIcon: true,
                  prefixIconUrl: const Icon(Icons.email_outlined),
                  fillColor: const Color(0xFFFFF5F3),
                  validator: Validators.validateEmail),

              const SizedBox(height: 16),

              // Password TextField
              CustomTextField(
                  labelText: tr("password"),
                  hintText: tr("password_hint"),
                  isPassword: true,
                  isShowPrefixIcon: true,
                  prefixIconUrl: const Icon(Icons.lock_outline),
                  isShowSuffixIcon: true,
                  suffixIconUrl: Icons.send, // This is used when isIcon is true.
                  fillColor: const Color(0xFFFFEFE9), // Light pinkish background
                  validator: Validators.validatePassword),

              const SizedBox(height: 16),

              // Restore password
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
                  )),

              SizedBox(height: MediaQuery.of(context).size.width * 0.4),

              // Login button
              CustomButton(
                buttonText: 'login'.tr(),
                icon: Icons.arrow_forward,
                onPressed: () {
                  Navigator.of(context).pushNamed(RouteHelper.welcome, arguments: WelcomeScreen());
                },
              ),

              const SizedBox(height: 16),

              // Sign Up button
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
}
