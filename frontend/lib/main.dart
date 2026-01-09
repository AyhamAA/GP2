import 'package:flutter/material.dart';
import 'package:test_app/screens/Admin/admin_profile_screen.dart';
import 'package:test_app/screens/Admin/calendar_screen.dart';
import 'package:test_app/screens/dr_DonorandRequester/dr_cart_screen.dart';
import 'package:test_app/screens/dr_DonorandRequester/donor/donor_request_screen.dart';
import 'package:test_app/screens/onboarding1.dart';
import 'package:test_app/screens/onboarding2.dart';
import 'package:test_app/screens/reset_password.dart';
import 'package:test_app/screens/dr_DonorandRequester/signup_screen.dart';
import 'package:test_app/screens/signin_screen.dart';
import 'package:test_app/widgets/admin_navigation.dart';
import 'package:test_app/widgets/dr_navigation.dart';
//import 'package:test_app/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Medshare',
      theme: ThemeData(
        useMaterial3: false,
        primaryColor: const Color(0xFF0E5962),
        fontFamily: 'Roboto',
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFBBBBBB)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFBBBBBB)),
          ),
        ),
      ),
      home: const Onboarding1(),
       routes: {
        '/onboarding1': (context) => const Onboarding1(),
        '/onboarding2': (context) => const Onboarding2(),
        '/signin': (context) => const SignInScreen(),
        '/resetpassword': (context) => const ResetPasswordScreen(),
        '/calendar': (context) => const CalendarScreen(),
        '/cart': (context) => const CartScreen(),
        '/signup':(context) => const SignUpScreen(),
      },
      
    );
  }
}
