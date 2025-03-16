import 'package:cached_network_image/cached_network_image.dart';
import 'package:event_planner/provider/auth_provider.dart';
import 'package:event_planner/utils/app_constants.dart';
import 'package:event_planner/utils/color_resources.dart';
import 'package:event_planner/utils/styles.dart';
import 'package:event_planner/utils/alerts.dart';
import 'package:event_planner/utils/validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../resuable_widgets/custom_button.dart';
import '../../resuable_widgets/custom_text_field.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController phoneController;
  late TextEditingController addressController;
  late String imageUrl;

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthenticationProvider>(context, listen: false);
    // Initialize controllers with current user data
    firstNameController = TextEditingController(text: authProvider.userModel?.firstName ?? "");
    lastNameController = TextEditingController(text: authProvider.userModel?.lastName ?? "");
    phoneController = TextEditingController(text: authProvider.userModel?.phoneNumber ?? "");
    addressController = TextEditingController(text: authProvider.userModel?.mailingAddress ?? "");
    imageUrl = authProvider.userModel?.profileImageUrl ?? "";

    _setListeners(authProvider);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      authProvider.onChange(val: false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthenticationProvider>(context);

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
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.grey.shade300, height: 1),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Consumer<AuthenticationProvider>(
              builder: (context, authProvider, _) {
                return GestureDetector(
                  onTap: () {
                    showImagePicker(context, authProvider);
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      authProvider.selectedImage != null
                          ? Container(
                              width: 120,
                              height: 120,
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
                            )
                          : ClipOval(
                              child: CachedNetworkImage(
                                imageUrl: authProvider.userModel?.profileImageUrl ??
                                    "", // Replace with user's image URL
                                width: 120,
                                height: 120,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => const CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.person, size: 100, color: Colors.grey),
                              ),
                            ),
                      ClipRRect(
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.black12),
                          child: const Icon(
                            Icons.photo_camera_outlined,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            // Input Fields
            CustomTextField(
              controller: firstNameController,
              labelText: "First Name",
              hintText: "Enter first name",
              validator: Validators.validateName,
              fillColor: ColorResources.secondaryFillColor,
            ),
            const SizedBox(height: 16),

            CustomTextField(
              controller: lastNameController,
              labelText: "Last Name",
              hintText: "Enter last name",
              validator: Validators.validateName,
              fillColor: ColorResources.secondaryFillColor,
            ),
            const SizedBox(height: 16),

            // Email Field (Disabled)
            CustomTextField(
              controller: TextEditingController(text: authProvider.userModel?.email ?? ""),
              labelText: "Email",
              hintText: "Enter email",
              fillColor: Colors.grey.shade300,
              isEnabled: false, // Make email read-only
            ),
            const SizedBox(height: 16),

            CustomTextField(
              controller: phoneController,
              labelText: "Phone number",
              hintText: "Enter phone number",
              validator: Validators.validatePhoneNumber,
              fillColor: ColorResources.secondaryFillColor,
            ),
            const SizedBox(height: 16),

            CustomTextField(
              controller: addressController,
              labelText: "Mailing address",
              hintText: "Enter address",
              validator: Validators.validateAddress,
              fillColor: ColorResources.secondaryFillColor,
            ),
            const SizedBox(height: 30),

            // Save Button
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: CustomButton(
                buttonText: "Save",
                isLoading: authProvider.isLoading || authProvider.isUploading,
                buttonLoadingText: authProvider.isUploading ? "Uploading.." : "Saving Data..",
                backgroundColor: ColorResources.primaryColor,
                onPressed: () => _saveProfile(authProvider),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _setListeners(AuthenticationProvider authProvider) {
    firstNameController.addListener(() => authProvider.onChange());
    lastNameController.addListener(() => authProvider.onChange());
    phoneController.addListener(() => authProvider.onChange());
    addressController.addListener(() => authProvider.onChange());
  }

  /// Submit updated user data to Firestore
  Future<void> _saveProfile(AuthenticationProvider authProvider) async {
    if (!authProvider.hasChanged && authProvider.selectedImage == null) {
      customSnackBar(AppConstants.noChanges, Colors.orange);
      return;
    }

    // Validate fields manually
    String? firstNameError = Validators.validateName(firstNameController.text);
    if (firstNameError != null) {
      customSnackBar(AppConstants.invalidFirstName, Colors.red);
      return;
    }

    String? lastNameError = Validators.validateName(lastNameController.text);
    if (lastNameError != null) {
      customSnackBar(AppConstants.invalidLastName, Colors.red);
      return;
    }

    String? phoneError = Validators.validatePhoneNumber(phoneController.text);
    if (phoneError != null) {
      customSnackBar(AppConstants.invalidPhoneNumber, Colors.red);
      return;
    }

    String? addressError = Validators.validateAddress(addressController.text);
    if (addressError != null) {
      customSnackBar(AppConstants.invalidAddress, Colors.red);
      return;
    }

    // Upload Image if selected
    String? imageUrlNew;
    if (authProvider.selectedImage != null) {
      imageUrlNew = await authProvider.uploadProfileImage();
    } else {
      imageUrlNew = imageUrl;
    }

    await authProvider.createUpdateUserData(
      firstName: firstNameController.text,
      lastName: lastNameController.text,
      email: authProvider.userModel?.email ?? "",
      phoneNumber: phoneController.text,
      mailingAddress: addressController.text,
      profileImageUrl: imageUrlNew!,
    );

    if (!mounted) return;
    customSnackBar(AppConstants.updateSuccess, Colors.green);
    Navigator.pop(context); // Go back after saving
  }
}
