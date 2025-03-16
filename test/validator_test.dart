import 'package:flutter_test/flutter_test.dart';
import 'package:event_planner/utils/validator.dart'; // adjust path as needed

void main() {
  test('Validators return expected error messages and null for valid inputs', () {
    // Email
    expect(Validators.validateEmail(null), equals("Email is required"));
    expect(Validators.validateEmail(''), equals("Email is required"));
    expect(Validators.validateEmail('invalidEmail'), equals("Enter a valid email"));
    expect(Validators.validateEmail('test@example.com'), equals(null));

    // Password
    expect(Validators.validatePassword(null), equals("Password is required"));
    expect(Validators.validatePassword(''), equals("Password is required"));
    expect(Validators.validatePassword('abc'), equals("Must have 1 uppercase, 1 lowercase & 1 number"));
    expect(Validators.validatePassword('Abc123'), equals(null));

    // Confirm Password
    expect(Validators.validateConfirmPassword(null, 'Abc123'), equals("Confirm password is required"));
    expect(Validators.validateConfirmPassword('', 'Abc123'), equals("Confirm password is required"));
    expect(Validators.validateConfirmPassword('Abc123', 'Abc1234'), equals("Passwords do not match"));
    expect(Validators.validateConfirmPassword('Abc123', 'Abc123'), equals(null));

    // First & Last Name
    expect(Validators.validateName(null), equals("This field is required"));
    expect(Validators.validateName(''), equals("This field is required"));
    expect(Validators.validateName('ab'), equals("Only letters (3-10 characters)"));
    expect(Validators.validateName('John'), equals(null));

    // Phone Number (Sri Lanka Format)
    expect(Validators.validatePhoneNumber(null), equals("Phone number is required"));
    expect(Validators.validatePhoneNumber(''), equals("Phone number is required"));
    expect(Validators.validatePhoneNumber('123456'), equals("Enter a valid Sri Lankan number"));
    expect(Validators.validatePhoneNumber('+94711234567'), equals(null));

    // Address
    expect(Validators.validateAddress(null), equals("Address is required"));
    expect(Validators.validateAddress(''), equals("Address is required"));
    expect(Validators.validateAddress('abc'), equals("Address must be 6-50 characters"));
    expect(Validators.validateAddress('a' * 51), equals("Address must be 6-50 characters"));
    expect(Validators.validateAddress('123 Main Street'), equals(null));
  });
}
