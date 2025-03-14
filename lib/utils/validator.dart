class Validators {
  // Validate Email
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Email is required";
    }
    // Email regex pattern
    final emailRegex = RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
    if (!emailRegex.hasMatch(value)) {
      return "Enter a valid email";
    }
    return null; // No error
  }

  // Validate Password
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Password is required";
    }
    // Password must contain: 1 uppercase, 1 lowercase, 1 number, at least 3 characters
    final passwordRegex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{3,}$');
    if (!passwordRegex.hasMatch(value)) {
      return "Must have 1 uppercase, 1 lowercase & 1 number";
    }
    return null;
  }

  // Validate Confirm Password
  static String? validateConfirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return "Confirm password is required";
    }
    if (value != password) {
      return "Passwords do not match";
    }
    return null;
  }

  // Validate First & Last Name
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return "This field is required";
    }
    final nameRegex = RegExp(r"^[a-zA-Z]{3,10}$");
    if (!nameRegex.hasMatch(value)) {
      return "Only letters (3-10 characters)";
    }
    return null;
  }

  // Validate Phone Number (Sri Lanka Format)
  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return "Phone number is required";
    }
    final phoneRegex = RegExp(r'^(?:\+94|0)(7[01245678])\d{7}$');
    if (!phoneRegex.hasMatch(value)) {
      return "Enter a valid Sri Lankan number";
    }
    return null;
  }

  // Validate Address
  static String? validateAddress(String? value) {
    if (value == null || value.isEmpty) {
      return "Address is required";
    }
    if (value.length < 6 || value.length > 50) {
      return "Address must be 6-50 characters";
    }
    return null;
  }
}
