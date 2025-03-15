import 'package:cached_network_image/cached_network_image.dart';
import 'package:event_planner/helper/route_helper.dart';
import 'package:event_planner/main.dart';
import 'package:event_planner/provider/auth_provider.dart';
import 'package:event_planner/provider/connectivity_provider.dart';
import 'package:event_planner/utils/alerts.dart';
import 'package:event_planner/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VersionWidget extends StatelessWidget {
  const VersionWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
}

class LogoutWidget extends StatelessWidget {
  const LogoutWidget({
    super.key,
    required this.context,
  });

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.logout, color: Colors.red),
      title: Text("Logout", style: poppinsMedium.copyWith(color: Colors.red, fontSize: 16)),
      onTap: () async {
        final connectivityProvider = Provider.of<ConnectivityProvider>(context, listen: false);
        if (!connectivityProvider.isConnected) {
          showNoInternetDialog(context);
          return;
        }
        await Provider.of<AuthenticationProvider>(context, listen: false).signOut();
        Navigator.of(MyApp.navigatorKey.currentContext!)
            .pushNamedAndRemoveUntil(RouteHelper.login, (route) => false);
      },
    );
  }
}

class UserHeaderWidget extends StatelessWidget {
  const UserHeaderWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthenticationProvider>(builder: (context, authProvider, child) {
      return UserAccountsDrawerHeader(
        decoration: const BoxDecoration(color: Colors.white),
        accountName: Text(
          authProvider.userModel?.firstName ?? "",
          style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        accountEmail: Text(
          authProvider.userModel?.email ?? "",
          style: TextStyle(color: Colors.black54, fontSize: 14),
        ),
        currentAccountPicture: CircleAvatar(
          backgroundColor: Colors.grey[200], // Placeholder background
          child: ClipOval(
            child: AspectRatio(
              aspectRatio: 1,
              child: CachedNetworkImage(
                imageUrl: authProvider.userModel?.profileImageUrl ?? "",
                fit: BoxFit.cover,
                placeholder: (context, url) => const CircularProgressIndicator(), // Loading indicator
                errorWidget: (context, url, error) =>
                    const Icon(Icons.person, size: 50, color: Colors.grey), // Fallback icon
              ),
            ),
          ),
        ),
      );
    });
  }
}
