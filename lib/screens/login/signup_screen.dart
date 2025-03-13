import 'package:event_planner/screens/login/login_screen.dart';
import 'package:event_planner/screens/login/welcome_screen.dart';
import 'package:event_planner/utils/validator.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../helper/route_helper.dart';
import '../../resuable_widgets/custom_text_field.dart';
import '../../resuable_widgets/custom_button.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({Key? key}) : super(key: key);

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Top spacing
              const SizedBox(height: 40),

              // Welcome Text
              Text(
                tr("welcome"),
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),

              // Subtitle Text
              Text(
                tr("welcome_portal"),
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                  fontFamily: 'Poppins',
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 40),

              // Email TextField
              CustomTextField(
                controller: emailController,
                labelText: tr("email"),
                hintText: 'your.email@gmail.com',
                isShowPrefixIcon: true,
                prefixIconUrl: const Icon(Icons.email_outlined),
                fillColor: const Color(0xFFFFF5F3),
                validator: Validators.validateEmail,
              ),

              const SizedBox(height: 16),

              // Password TextField
              CustomTextField(
                controller: passwordController,
                labelText: tr("password"),
                hintText: '********',
                isPassword: true,
                isShowPrefixIcon: true,
                prefixIconUrl: const Icon(Icons.lock_outline),
                isShowSuffixIcon: true,
                fillColor: const Color(0xFFFFEFE9),
                validator: Validators.validatePassword,
              ),

              const SizedBox(height: 16),

              // Confirm Password TextField
              CustomTextField(
                controller: confirmPasswordController,
                labelText: tr("confirm_password"),
                hintText: '********',
                isPassword: true,
                isShowPrefixIcon: true,
                prefixIconUrl: const Icon(Icons.lock_outline),
                isShowSuffixIcon: true,
                fillColor: const Color(0xFFFFEFE9),
                validator: (value) => Validators.validateConfirmPassword(value, passwordController.text),
              ),

              SizedBox(height: MediaQuery.of(context).size.width * 0.35),
              // Buttons (Sign Up & Login)
              CustomButton(
                buttonText: tr("sign_up"),
                icon: Icons.arrow_forward,
                onPressed: () {
                  // TODO: Handle Sign-Up Logic
                },
              ),
              const SizedBox(height: 16),
              CustomButton(
                buttonText: tr("login"),
                icon: Icons.arrow_forward,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
