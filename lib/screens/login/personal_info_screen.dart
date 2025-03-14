import 'package:event_planner/helper/route_helper.dart';
import 'package:event_planner/main.dart';
import 'package:event_planner/provider/auth_provider.dart';
import 'package:event_planner/screens/navigation/nav_bar_screen.dart';
import 'package:event_planner/utils/alerts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../resuable_widgets/custom_button.dart';
import '../../resuable_widgets/custom_text_field.dart';
import '../../utils/styles.dart';
import '../../utils/validator.dart';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({Key? key}) : super(key: key);

  @override
  _PersonalInfoScreenState createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  /// **Method to Validate Fields and Submit Profile**
  Future<void> _submitProfile(AuthenticationProvider authProvider) async {
    // Validate fields manually
    String? firstNameError = Validators.validateName(firstNameController.text);
    if (firstNameError != null) {
      customSnackBar(context, "Invalid First Name", Colors.red);
      return;
    }

    String? lastNameError = Validators.validateName(lastNameController.text);
    if (lastNameError != null) {
      customSnackBar(context, "Invalid Last Name", Colors.red);
      return;
    }

    String? emailError = Validators.validateEmail(emailController.text);
    if (emailError != null) {
      customSnackBar(context, "Invalid Email", Colors.red);
      return;
    }

    String? phoneError = Validators.validatePhoneNumber(phoneController.text);
    if (phoneError != null) {
      customSnackBar(context, "Invalid Phone Number", Colors.red);
      return;
    }

    String? addressError = Validators.validateAddress(addressController.text);
    if (addressError != null) {
      customSnackBar(context, "Invalid Address", Colors.red);
      return;
    }

    // Upload Image if selected
    String? imageUrl;
    if (authProvider.selectedImage != null) {
      imageUrl = await authProvider.uploadProfileImage();
    }

    // Submit data to Firestore
    await authProvider.createUpdateUserData(
      firstName: firstNameController.text,
      lastName: lastNameController.text,
      email: emailController.text,
      phoneNumber: phoneController.text,
      mailingAddress: addressController.text,
      profileImageUrl: imageUrl!,
    );

    if (authProvider.errorMessage != null) {
      customSnackBar(context, authProvider.errorMessage ?? "Something went wrong", Colors.red);
    } else {
      // Show success message
      customSnackBar(context, "Profile updated successfully!", Colors.green);
      Navigator.of(MyApp.navigatorKey.currentContext!)
          .pushNamedAndRemoveUntil(RouteHelper.navBar, (route) => false, arguments: NavBarScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthenticationProvider>(context);
    emailController.text = authProvider.user?.email ?? "";
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    // Title
                    Text(
                      "Personal info",
                      style: poppinsBold.copyWith(
                        fontSize: 24,
                      ),
                    ),

                    const SizedBox(height: 4),

                    // Subtitle
                    const Text(
                      "You can add your personal data now or do it later",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.black54,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // First Name
                    CustomTextField(
                      controller: firstNameController,
                      labelText: "First Name",
                      hintText: "Jane",
                      validator: Validators.validateName,
                    ),
                    const SizedBox(height: 16),

                    // Last Name
                    CustomTextField(
                      controller: lastNameController,
                      labelText: "Last Name",
                      hintText: "Cooper",
                      validator: Validators.validateName,
                    ),
                    const SizedBox(height: 16),

                    // Email
                    CustomTextField(
                      controller: emailController,
                      labelText: "Email",
                      hintText: "jane.c@gmail.com",
                      validator: Validators.validateEmail,
                      isEnabled: false,
                      fillColor: Colors.grey.shade200,
                    ),
                    const SizedBox(height: 16),

                    // Phone Number
                    CustomTextField(
                      controller: phoneController,
                      labelText: "Phone number",
                      hintText: "02 9371 9090",
                      inputType: TextInputType.number,
                      validator: Validators.validatePhoneNumber,
                    ),
                    const SizedBox(height: 16),

                    // Mailing Address
                    CustomTextField(
                      controller: addressController,
                      labelText: "Mailing address",
                      hintText: "56 O’Mally Road, ST LEONARDS, 2065, NSW",
                      validator: Validators.validateAddress,
                    ),

                    const SizedBox(height: 24), // Extra space before buttons
                  ],
                ),
              ),
            ),

            // Buttons (Back & Next)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      buttonText: "Back",
                      iconBeforeText: true,
                      icon: Icons.arrow_back,
                      backgroundColor: const Color(0xFFF2E8E5),
                      textColor: Colors.black,
                      iconColor: Colors.black54,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Consumer<AuthenticationProvider>(builder: (context, authProvider, _) {
                    return Expanded(
                      child: CustomButton(
                        buttonText: "Next",
                        icon: Icons.arrow_forward,
                        onPressed: () async {
                          await _submitProfile(authProvider);
                        },
                        isLoading: authProvider.isLoading,
                        buttonLoadingText: "Saving..",
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
