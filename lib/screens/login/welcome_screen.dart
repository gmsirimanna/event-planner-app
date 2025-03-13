import 'package:event_planner/screens/login/personal_info_screen.dart';
import 'package:event_planner/utils/color_resources.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

import '../../helper/route_helper.dart';
import '../../resuable_widgets/custom_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
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

            // Profile Upload Button
            GestureDetector(
              onTap: () {
                // TODO: Implement image picker logic
              },
              child: Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  color: ColorResources.secondaryFillColor, // Light pinkish background
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.photo_camera_outlined,
                    color: ColorResources.primaryColor, // Camera icon color
                    size: 25,
                  ),
                ),
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
                  Navigator.of(context).pushNamed(RouteHelper.personalInfo, arguments: PersonalInfoScreen());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
