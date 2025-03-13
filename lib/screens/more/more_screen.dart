import 'package:cached_network_image/cached_network_image.dart';
import 'package:event_planner/helper/route_helper.dart';
import 'package:event_planner/main.dart';
import 'package:event_planner/screens/login/login_screen.dart';
import 'package:event_planner/screens/more/edit_profile_screen.dart';
import 'package:event_planner/utils/color_resources.dart';
import 'package:event_planner/utils/styles.dart';
import 'package:flutter/material.dart';
import '../../resuable_widgets/custom_text_field.dart';
import '../../resuable_widgets/custom_button.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({Key? key}) : super(key: key);

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildUserHeader(),
          _buildLogoutButton(context),
          const Spacer(),
          _buildVersionText(),
        ],
      ),
    );
  }

  Widget _buildUserHeader() {
    return UserAccountsDrawerHeader(
      decoration: const BoxDecoration(color: Colors.white),
      accountName: const Text(
        "Jane Cooper",
        style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
      ),
      accountEmail: const Text(
        "jane.c@gmail.com",
        style: TextStyle(color: Colors.black54, fontSize: 14),
      ),
      currentAccountPicture: CircleAvatar(
        backgroundColor: Colors.grey[200], // Placeholder background
        child: ClipOval(
          child: CachedNetworkImage(
            imageUrl:
                "https://images.unsplash.com/photo-1633332755192-727a05c4013d?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8dXNlcnxlbnwwfHwwfHx8MA%3D%3D", // Replace with the actual URL
            width: 80,
            height: 80,
            fit: BoxFit.cover,
            placeholder: (context, url) => const CircularProgressIndicator(), // Loading indicator
            errorWidget: (context, url, error) =>
                const Icon(Icons.person, size: 50, color: Colors.grey), // Fallback icon
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.logout, color: Colors.red),
      title: Text("Logout", style: poppinsMedium.copyWith(color: Colors.red, fontSize: 16)),
      onTap: () {
        // Provider.of<AuthenticationProvider>(context, listen: false).signOut();
        Navigator.of(MyApp.navigatorKey.currentContext!)
            .pushNamedAndRemoveUntil(RouteHelper.login, (route) => false, arguments: LoginScreen());
      },
    );
  }

  Widget _buildVersionText() {
    return const Padding(
      padding: EdgeInsets.only(bottom: 20, left: 16),
      child: Center(
        child: Text(
          "Version 0.0.1",
          style: TextStyle(color: Colors.grey, fontSize: 14),
        ),
      ),
    );
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
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    SizedBox(
                      width: 120,
                      height: 120,
                      child: CircleAvatar(
                        backgroundColor: Colors.grey[200], // Placeholder background
                        child: ClipOval(
                          child: CachedNetworkImage(
                            imageUrl:
                                "https://images.unsplash.com/photo-1633332755192-727a05c4013d?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8dXNlcnxlbnwwfHwwfHx8MA%3D%3D", // Replace with the actual URL
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(), // Loading indicator
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.person, size: 50, color: Colors.grey), // Fallback icon
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // First Name
                    const CustomTextField(
                      labelText: "First Name",
                      hintText: "Jane",
                      fillColor: ColorResources.secondaryFillColor,
                      isShowBorder: true,
                      isEnabled: false, // Disable input
                    ),
                    const SizedBox(height: 16),

                    // Last Name
                    const CustomTextField(
                      labelText: "Last Name",
                      hintText: "Cooper",
                      fillColor: ColorResources.secondaryFillColor,
                      isShowBorder: true,
                      isEnabled: false,
                    ),
                    const SizedBox(height: 16),

                    // Email
                    const CustomTextField(
                      labelText: "Email",
                      hintText: "jane.c@gmail.com",
                      fillColor: ColorResources.secondaryFillColor,
                      isShowBorder: true,
                      isEnabled: false,
                    ),
                    const SizedBox(height: 16),

                    // Phone Number
                    const CustomTextField(
                      labelText: "Phone number",
                      hintText: "02 9371 9090",
                      fillColor: ColorResources.secondaryFillColor,
                      isShowBorder: true,
                      isEnabled: false,
                    ),
                    const SizedBox(height: 16),

                    // Mailing Address
                    const CustomTextField(
                      labelText: "Mailing address",
                      hintText: "56 O’Mally Road, ST LEONARDS, 2065, NSW",
                      fillColor: ColorResources.secondaryFillColor,
                      isShowBorder: true,
                      isEnabled: false,
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
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
}
