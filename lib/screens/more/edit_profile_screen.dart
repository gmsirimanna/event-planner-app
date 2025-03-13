import 'package:event_planner/utils/color_resources.dart';
import 'package:event_planner/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../resuable_widgets/custom_button.dart';
import '../../resuable_widgets/custom_text_field.dart';

class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({Key? key}) : super(key: key);

  final TextEditingController firstNameController = TextEditingController(text: "Jane");
  final TextEditingController lastNameController = TextEditingController(text: "Cooper");
  final TextEditingController emailController = TextEditingController(text: "jane.c@gmail.com");
  final TextEditingController phoneController = TextEditingController(text: "02 9371 9090");
  final TextEditingController addressController =
      TextEditingController(text: "56 O’Mally Road, ST LEONARDS, 2065, NSW");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile", style: poppinsMedium.copyWith(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1), // Small line height
          child: Container(
            color: Colors.grey.shade300, // Light grey divider
            height: 1, // Line thickness
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Image with Edit Option

            Stack(
              children: [
                ClipOval(
                  child: CachedNetworkImage(
                    imageUrl:
                        "https://randomuser.me/api/portraits/women/44.jpg", // Replace with user's image URL
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.person, size: 100, color: Colors.grey),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  top: 0,
                  left: 0,
                  child: GestureDetector(
                    onTap: () {
                      // Implement image picker
                    },
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Colors.black12,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.camera_alt, color: Colors.white, size: 18),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Input Fields
            CustomTextField(
              controller: firstNameController,
              labelText: "First Name",
              hintText: "Enter first name",
              fillColor: const Color(0xFFFFF5F3),
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: lastNameController,
              labelText: "Last Name",
              hintText: "Enter last name",
              fillColor: const Color(0xFFFFF5F3),
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: emailController,
              labelText: "Email",
              hintText: "Enter email",
              fillColor: const Color(0xFFFFF5F3),
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: phoneController,
              labelText: "Phone number",
              hintText: "Enter phone number",
              fillColor: const Color(0xFFFFF5F3),
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: addressController,
              labelText: "Mailing address",
              hintText: "Enter address",
              fillColor: const Color(0xFFFFF5F3),
            ),
            const SizedBox(height: 30),

            // Save Button
            CustomButton(
              buttonText: "Save",
              backgroundColor: ColorResources.primaryColor,
              onPressed: () {
                // Implement Save logic
              },
            ),
          ],
        ),
      ),
    );
  }
}
