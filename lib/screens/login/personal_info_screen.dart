import 'package:flutter/material.dart';
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
  final _formKey = GlobalKey<FormState>();

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  void _validateForm() {
    if (_formKey.currentState!.validate()) {
      print("Form is valid. Proceed to next step.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Form(
                  key: _formKey,
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
                  Expanded(
                    child: CustomButton(
                      buttonText: "Next",
                      icon: Icons.arrow_forward,
                      onPressed: _validateForm,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
