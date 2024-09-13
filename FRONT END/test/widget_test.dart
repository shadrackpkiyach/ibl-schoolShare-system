import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:student/screens/authentication_screen.dart';

void main() {
  testWidgets('UI Test for AuthenticationScreen', (WidgetTester tester) async {
    // Build our app and trigger a frame
    await tester.pumpWidget(const MaterialApp(
      home: AuthenticationScreen(),
    ));

    // Verify that the 'Login' tab is rendered
    final loginTab = find.text('Login').first;
    expect(loginTab, findsOneWidget);

    // Verify that the 'Register' tab is rendered
    final registerTab = find.text('Register').first;
    expect(registerTab, findsOneWidget);

    // Tap on the 'Register' tab
    await tester.tap(registerTab);
    await tester.pump();

    // Verify that the 'Name' text field is rendered
    expect(find.byKey(const Key('nameTextField')), findsOneWidget);

    // Verify that the 'Email Address' text field is rendered
    expect(find.byKey(const Key('emailTextField')), findsOneWidget);

    // Verify that the 'Phone number' text field is rendered
    expect(find.byKey(const Key('phoneNumberTextField')), findsOneWidget);

    // Verify that the 'Password' text field is rendered
    expect(find.byKey(const Key('passwordTextField')), findsOneWidget);

    // Verify that the 'Confirm Password' text field is rendered
    expect(find.byKey(const Key('confirmPasswordTextField')), findsOneWidget);

    // Verify that the 'Accept Terms and Conditions' checkbox is rendered
    expect(find.byKey(const Key('termsCheckbox')), findsOneWidget);

    // Verify that the 'register' button is rendered
    expect(find.text('register'), findsOneWidget);
  });
}
