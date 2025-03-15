// ignore_for_file: constant_identifier_names

import 'package:event_planner/data/model/language_model.dart';

class AppConstants {
  // Shared Key
  static const String COUNTRY_CODE = 'country_code';
  static const String LANGUAGE_CODE = 'language_code';
  static const String IS_LOGGED_IN = 'isLoggedIn';
  static const String UUID = 'userUUID';
  static const String USERNAME = 'userName';

  //Const Strings

  static const String somethingWrong = "Something went wrong !";
  static const String invalidEmail = "Please enter a valid email address.";
  static const String invalidPassword = "Please enter valid password";
  static const String userNotFound =
      "No user found with these credentials. Please check your email and password or sign up.";
  static const String authError = "Invalid email or password. Please try again.";

  static const String invalidFirstName = "Please enter a valid first name (3-10 letters).";
  static const String invalidLastName = "Please enter a valid last name (3-10 letters).";
  static const String invalidPhoneNumber =
      "Please enter a valid Sri Lankan phone number (e.g., +947XXXXXXXX).";
  static const String invalidAddress = "Please enter a valid address (6-50 characters).";

  static const String uploadFailed = "Failed to upload profile image. Please try again.";
  static const String updateFailed = "Something went wrong while updating your profile. Please try again.";
  static const String updateSuccess = "Your profile has been updated successfully!";

  static const String personalInfo = "Personal info";
  static const String personalInfoDes = "*You can add your personal data now";
  static const String resendEmail = "Enter your email and we will send you a link to reset your password.";
  static const String confirmPasswordRequired = "Confirm password is required.";
  static const String emailAlreadyInUse = "This email is already registered. Try logging in instead.";
  static const String noChanges = "No changes detected!";

  static List<LanguageModel> languages = [
    LanguageModel(imageUrl: "", languageName: 'English', countryCode: 'US', languageCode: 'en'),
    LanguageModel(imageUrl: "", languageName: 'සිංහල', countryCode: 'SL', languageCode: 'si'),
  ];
}
