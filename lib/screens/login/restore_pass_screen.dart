import 'package:event_planner/provider/auth_provider.dart';
import 'package:event_planner/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import '../../resuable_widgets/custom_button.dart';
import '../../resuable_widgets/custom_text_field.dart';
import '../../utils/validator.dart';

class RestorePasswordScreen extends StatelessWidget {
  RestorePasswordScreen({Key? key}) : super(key: key);

  final TextEditingController emailController = TextEditingController();

  void sendPasswordReset(BuildContext context, AuthenticationProvider authProvider) {
    String? emailError = Validators.validateEmail(emailController.text.trim());
    if (emailError != null) {
      customSnackBar(context, emailError, Colors.red);
      return;
    }

    authProvider.clearMessages();
    authProvider.resetPassword(emailController.text.trim());
  }

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
              SizedBox(height: MediaQuery.of(context).size.width * 0.3),

              // Restore Password title
              Text(
                'restore_password'.tr(),
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                "Enter your email and we will send you a link to reset your password.",
                style: const TextStyle(fontSize: 16, color: Colors.black54),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: MediaQuery.of(context).size.width * 0.2),

              // Email TextField
              CustomTextField(
                controller: emailController,
                labelText: tr("email"),
                hintText: tr("email_hint"),
                isShowPrefixIcon: true,
                prefixIconUrl: const Icon(Icons.email_outlined),
                fillColor: const Color(0xFFFFF5F3),
                validator: Validators.validateEmail,
              ),

              SizedBox(height: MediaQuery.of(context).size.width * 0.1),

              // Show success message if email is sent
              if (authProvider.successMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    authProvider.successMessage!,
                    style: const TextStyle(color: Colors.green, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ),

              // Show error message from Provider
              if (authProvider.errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    authProvider.errorMessage!,
                    style: const TextStyle(color: Colors.red, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ),

              // Send Reset Link Button
              CustomButton(
                buttonText: authProvider.canResend ? 'Send Reset Link' : 'Resend after 30s',
                icon: Icons.email,
                isLoading: authProvider.isLoading ? true : false,
                onPressed: authProvider.canResend ? () => sendPasswordReset(context, authProvider) : () {},
              ),

              const SizedBox(height: 16),

              // Back to Login button
              CustomButton(
                buttonText: 'Back to Login',
                icon: Icons.arrow_back,
                onPressed: () {
                  authProvider.clearMessages();
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
