import 'package:easy_localization/easy_localization.dart';
import 'package:event_planner/screens/login/login_screen.dart';
import 'package:event_planner/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mockito/mockito.dart';

// Import the generated mocks file.
import 'mocks.mocks.dart';

void main() {
  group('LoginScreen Unit Tests', () {
    late MockAuthenticationProvider mockAuthProvider;

    setUp(() {
      mockAuthProvider = MockAuthenticationProvider();
    });

    // Create a test widget tree that provides AuthenticationProvider and EasyLocalization.
    Widget createWidgetUnderTest() {
      return EasyLocalization(
        supportedLocales: const [Locale('en', 'US')],
        path: 'assets/translations', // Adjust this to your translations folder path
        fallbackLocale: const Locale('en', 'US'),
        child: MaterialApp(
          home: ChangeNotifierProvider<AuthenticationProvider>.value(
            value: mockAuthProvider,
            child: const LoginScreen(),
          ),
        ),
      );
    }

    testWidgets('Login with invalid email does not trigger signIn and shows error',
        (WidgetTester tester) async {
      // Build the widget tree.
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Find email and password fields and the login button by their Keys.
      final emailField = find.byKey(const Key('emailField'));
      final passwordField = find.byKey(const Key('passwordField'));
      final loginButton = find.byKey(const Key('loginButton'));

      // Verify the widgets exist.
      expect(emailField, findsOneWidget);
      expect(passwordField, findsOneWidget);
      expect(loginButton, findsOneWidget);

      // Enter an invalid email and a valid password.
      await tester.enterText(emailField, 'invalidEmail');
      await tester.enterText(passwordField, 'ValidPass123');

      // Tap the login button.
      await tester.tap(loginButton);
      await tester.pump(); // Process the tap event

      // Verify that signIn is not called.
      verifyNever(mockAuthProvider.signIn(any, any));

      // Check that a SnackBar is shown with the appropriate error message.
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.textContaining("Enter a valid email"), findsOneWidget);
    });
  });
}
