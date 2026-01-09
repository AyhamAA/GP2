import 'package:flutter/material.dart';

class Onboarding1 extends StatelessWidget {
  const Onboarding1({super.key});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/onboarding1.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 655),
            const Text(
              "Welcome to your MedShare app",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Color(0xFF085D62),
                shadows: [
                  Shadow(color: Colors.black54, offset: Offset(2, 2), blurRadius: 4),
                ],
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/signin');
                    },
                    child: const Text(
                      "Skip",
                      style: TextStyle(fontSize: 20, color: Color(0xFF085D62)),
                    ),
                  ),
                  FloatingActionButton(
                    backgroundColor: Color.fromRGBO(33, 86, 106, 1.0),
                    onPressed: () {
                      Navigator.pushNamed(context, '/onboarding2');
                    },
                    child: const Icon(Icons.arrow_forward, color: Colors.white),
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
