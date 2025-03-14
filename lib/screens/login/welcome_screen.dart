import 'package:event_planner/provider/auth_provider.dart';
import 'package:event_planner/screens/login/personal_info_screen.dart';
import 'package:event_planner/utils/alerts.dart';
import 'package:event_planner/utils/color_resources.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../helper/route_helper.dart';
import '../../resuable_widgets/custom_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<AuthenticationProvider>(builder: (context, authProvider, _) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              // Welcome Text
              const Text(
                "Welcome",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "You are logged in for the first time and can\nupload a profile photo",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.black54,
                  fontFamily: 'Poppins',
                ),
              ),

              const SizedBox(height: 40),

              // Profile Image Upload Section
              GestureDetector(
                onTap: () {
                  showImagePicker(context, authProvider);
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: ColorResources.secondaryFillColor,
                        shape: BoxShape.circle,
                        image: authProvider.selectedImage != null
                            ? DecorationImage(
                                image: FileImage(authProvider.selectedImage!),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                    ),
                    ClipRRect(
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.black12),
                        child: const Icon(
                          Icons.photo_camera_outlined,
                          color: ColorResources.primaryColor,
                          size: 30,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 60),

              // Spacer to push the button to the bottom
              const Spacer(),

              // Next Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: CustomButton(
                  buttonText: 'Next',
                  icon: Icons.arrow_forward,
                  onPressed: () {
                    if (authProvider.selectedImage == null) {
                      customSnackBar("FILL IMAGE", Colors.red);
                      return;
                    }
                    Navigator.of(context)
                        .pushNamed(RouteHelper.personalInfo, arguments: PersonalInfoScreen());
                  },
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
