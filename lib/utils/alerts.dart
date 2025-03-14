import 'package:event_planner/main.dart';
import 'package:event_planner/provider/auth_provider.dart';
import 'package:event_planner/provider/connectivity_provider.dart';
import 'package:event_planner/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:event_planner/utils/dimensions.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

customSnackBar(String msg, Color color) =>
    ScaffoldMessenger.of(MyApp.navigatorKey.currentContext!).showSnackBar(SnackBar(
      duration: const Duration(seconds: 2),
      content: Text(
        msg,
        style: TextStyle(
          fontSize: Dimensions.fontSizeSmall,
          color: Colors.white,
        ),
      ),
      backgroundColor: color,
      padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
    ));

/// Show Image Picker Alert Dialog
showImagePicker(BuildContext context, AuthenticationProvider authProvider) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(
        "Choose Image Source",
        style: poppinsMedium,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.camera, color: Colors.blue),
            title: const Text("Camera"),
            onTap: () {
              authProvider.selectImage(ImageSource.camera);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library, color: Colors.green),
            title: const Text("Gallery"),
            onTap: () {
              authProvider.selectImage(ImageSource.gallery);
              Navigator.pop(context);
            },
          ),
        ],
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );
}

void showNoInternetDialog(BuildContext context) {
  showDialog(
    context: MyApp.navigatorKey.currentContext!,
    barrierDismissible: false, // User cannot dismiss it
    builder: (context) {
      return AlertDialog(
        title: const Text("No Internet"),
        content: const Text("You are offline. Please check your connection."),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
        ],
      );
    },
  );
}
