import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:student/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Test login and registration flow', (WidgetTester tester) async {
    // Start the app
    app.main();

    // Wait for the app to render
    await tester.pumpAndSettle();

    // Tap on the Register tab
    await tester.tap(find.text('Register'));
    await tester.pumpAndSettle();

    // Fill out the registration form
    await tester.enterText(find.byKey(const Key('nameTextField')), 'John Doe');
    await tester.enterText(
        find.byKey(const Key('emailTextField')), 'john@example.com');
    await tester.enterText(
        find.byKey(const Key('phoneNumberTextField')), '1234567890');
    await tester.enterText(
        find.byKey(const Key('passwordTextField')), 'password');
    await tester.enterText(
        find.byKey(const Key('confirmPasswordTextField')), 'password');

    // Check the terms and conditions checkbox
    await tester.tap(find.byKey(const Key('termsCheckbox')));

    // Tap on the Register button
    await tester.tap(find.text('register'));
    await tester.pumpAndSettle();

    // Check if registration was successful by looking for a success message or navigating to another screen

    // Tap on the Login tab
    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();

    // Fill out the login form
    await tester.enterText(
        find.byKey(const Key('emailTextField')), 'john@example.com');
    await tester.enterText(
        find.byKey(const Key('passwordTextField')), 'password');

    // Tap on the Login button
    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();

    // Check if login was successful by looking for a success message or navigating to another screen
  });
}
