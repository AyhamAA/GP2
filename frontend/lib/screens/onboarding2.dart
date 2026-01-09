import 'package:flutter/material.dart';

class Onboarding2 extends StatelessWidget {
  const Onboarding2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/onboarding2.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 635),
            const Text(
              "Your trusted source for medicine & medical equipment",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Color(0xFF085D62),
                shadows: [
                  Shadow(
                    color: Colors.black54,
                    offset: Offset(2, 2),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
            const SizedBox(),
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/onboarding1');
                    },
                    child: const Text(
                      "Back",
                      style: TextStyle(fontSize: 20, color: Color(0xFF085D62)),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromRGBO(33, 86, 106, 1.0),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/signin');
                    },
                    child: const Text(
                      "Get started",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
