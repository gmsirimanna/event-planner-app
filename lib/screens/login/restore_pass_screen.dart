// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../resuable_widgets/custom_button.dart';
import '../../resuable_widgets/custom_text_field.dart';
import '../../utils/validator.dart';
import '../../utils/color_resources.dart';
import '../../utils/styles.dart';

class RestorePasswordScreen extends StatefulWidget {
  const RestorePasswordScreen({Key? key}) : super(key: key);

  @override
  _RestorePasswordScreenState createState() => _RestorePasswordScreenState();
}

class _RestorePasswordScreenState extends State<RestorePasswordScreen> {
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();

  bool _isLoading = false;
  String? _successMessage;
  String? _errorMessage;

  void _sendPasswordResetEmail() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _successMessage = null;
        _errorMessage = null;
      });

      // try {
      //   await _auth.sendPasswordResetEmail(email: emailController.text.trim());

      //   setState(() {
      //     _successMessage = "A password reset link has been sent to your email.";
      //   });

      //   // Navigate back to Login after a delay
      //   Future.delayed(const Duration(seconds: 3), () {
      //     Navigator.pop(context);
      //   });
      // } on FirebaseAuthException catch (e) {
      //   setState(() {
      //     _errorMessage = e.message;
      //   });
      // } finally {
      //   setState(() {
      //     _isLoading = false;
      //   });
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Form(
            key: _formKey,
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
                if (_successMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      _successMessage!,
                      style: const TextStyle(color: Colors.green, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ),

                // Show error message if there was an issue
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ),

                // Send Reset Link Button
                _isLoading
                    ? const Center(child: CircularProgressIndicator()) // ✅ Show loading spinner
                    : CustomButton(
                        buttonText: 'Send Reset Link',
                        icon: Icons.email,
                        onPressed: _sendPasswordResetEmail, // ✅ Call password reset function
                      ),

                const SizedBox(height: 16),

                // Back to Login button
                CustomButton(
                  buttonText: 'Back to Login',
                  icon: Icons.arrow_back,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
