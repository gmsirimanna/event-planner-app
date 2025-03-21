import 'package:cached_network_image/cached_network_image.dart';
import 'package:event_planner/helper/route_helper.dart';
import 'package:event_planner/provider/auth_provider.dart';
import 'package:event_planner/screens/more/edit_profile_screen.dart';
import 'package:event_planner/screens/more/widgets/drawer_widget.dart';
import 'package:event_planner/utils/color_resources.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../resuable_widgets/custom_text_field.dart';
import '../../resuable_widgets/custom_button.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({Key? key}) : super(key: key);

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final authProvider = Provider.of<AuthenticationProvider>(context, listen: false);
      authProvider.listenToUserData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1), // Small line height
          child: Container(
            color: Colors.grey.shade300, // Light grey divider
            height: 1, // Line thickness
          ),
        ),
      ),
      drawer: _buildDrawer(context),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Image
            Expanded(
              child: SingleChildScrollView(
                child: Consumer<AuthenticationProvider>(builder: (context, authProvider, child) {
                  updateControllers(authProvider);
                  return Column(
                    children: [
                      SizedBox(height: 20),
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
                          BoxShadow(
                            spreadRadius: 0.1,
                            color: Colors.black12,
                            blurRadius: 1,
                          ),
                        ]),
                        child: CircleAvatar(
                          backgroundColor: Colors.grey[200], // Placeholder background
                          child: ClipOval(
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: CachedNetworkImage(
                                imageUrl: authProvider.userModel?.profileImageUrl ?? "",
                                fit: BoxFit.cover,
                                placeholder: (context, url) =>
                                    const CircularProgressIndicator(), // Loading indicator
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.person, size: 50, color: Colors.grey), // Fallback icon
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // First Name
                      CustomTextField(
                        controller: firstNameController,
                        labelText: "First Name",
                        hintText: "Jane",
                        fillColor: ColorResources.secondaryFillColor,
                        isShowBorder: true,
                        isEnabled: false, // Disable input
                      ),
                      const SizedBox(height: 16),

                      // Last Name
                      CustomTextField(
                        controller: lastNameController,
                        labelText: "Last Name",
                        hintText: "Cooper",
                        fillColor: ColorResources.secondaryFillColor,
                        isShowBorder: true,
                        isEnabled: false,
                      ),
                      const SizedBox(height: 16),

                      // Email
                      CustomTextField(
                        controller: emailController,
                        labelText: "Email",
                        hintText: "jane.c@gmail.com",
                        fillColor: ColorResources.secondaryFillColor,
                        isShowBorder: true,
                        isEnabled: false,
                      ),
                      const SizedBox(height: 16),

                      // Phone Number
                      CustomTextField(
                        controller: phoneController,
                        labelText: "Phone number",
                        hintText: "02 9371 9090",
                        fillColor: ColorResources.secondaryFillColor,
                        isShowBorder: true,
                        isEnabled: false,
                      ),
                      const SizedBox(height: 16),

                      // Mailing Address
                      CustomTextField(
                        controller: addressController,
                        labelText: "Mailing address",
                        hintText: "56 O’Mally Road, ST LEONARDS, 2065, NSW",
                        fillColor: ColorResources.secondaryFillColor,
                        isShowBorder: true,
                        isEnabled: false,
                      ),
                      const SizedBox(height: 24),
                    ],
                  );
                }),
              ),
            ),
            // Edit Button
            CustomButton(
              buttonText: "Edit",
              onPressed: () {
                Navigator.of(context).pushNamed(RouteHelper.editProfile, arguments: EditProfileScreen());
              },
            ),

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void updateControllers(AuthenticationProvider authProvider) {
    if (authProvider.userModel != null) {
      firstNameController.text = authProvider.userModel!.firstName;
      lastNameController.text = authProvider.userModel!.lastName;
      emailController.text = authProvider.userModel!.email;
      phoneController.text = authProvider.userModel!.phoneNumber;
      addressController.text = authProvider.userModel!.mailingAddress;
    }
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserHeaderWidget(),
          LogoutWidget(context: context),
          const Spacer(),
          AppVersionText(),
        ],
      ),
    );
  }
}
