import 'package:flutter/material.dart';
import 'package:test_app/widgets/dr_navigation.dart';

class DrNotificationScreen extends StatefulWidget {
  const DrNotificationScreen({super.key});

  @override
  State<DrNotificationScreen> createState() => _DrNotificationScreenState();
}

class _DrNotificationScreenState extends State<DrNotificationScreen> {
  bool isButtonActive = true;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: width * 0.05,
            vertical: height * 0.02,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(width, height),
              SizedBox(height: height * 0.04),
              _buildNotificationButton(width, height),
              SizedBox(height: height * 0.03),
              _buildNotificationDays(width, height),
              SizedBox(height: height * 0.03),
              _buildNotificationItems(width, height),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(double width, double height) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const DrNavigationpage())),
          child: const Icon(Icons.arrow_back_ios_new,
              color: Colors.black, size: 28),
        ),
        SizedBox(width: width * 0.21),
        Text(
          'Notifications',
          style: TextStyle(
            color: Colors.black,
            fontSize: width * 0.065,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationButton(double width, double height) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildActionButton('All', isButtonActive, () {
          setState(() {
            isButtonActive = true;
          });
        }),
        /*SizedBox(width: width * 0.04),
        _buildActionButton('Unread', !isButtonActive, () {
          setState(() {
            isButtonActive = false;
          });
        }),*/
      ],
    );
  }

  Widget _buildActionButton(String text, bool isActive, VoidCallback? onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF34AFB7) : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: const Color(0xFF34AFB7), width: 1.5),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isActive ? Colors.white : const Color(0xFF34AFB7),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationDays(double width, double height) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Today",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 2),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "You have 3 notifications today.",
              style: TextStyle(fontSize: 15, color: Colors.black87),
            ),
            Text(
              "Mark As Read",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
                color: const Color(0xFF34AFB7),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNotificationItems(double width, double height) {
    final notificationItems = [
      {'message': 'Your order will be ready on 26 NOV','time': '10:00 AM'},
      {'message': 'Check your email verification code','time': '12:00 PM'},
      {'message': 'Your order has been successfully delivered','time': '9:00 AM'},
      {'message': 'Your order just accepted','time': '10:30 PM'},
    ];

    return Column(
      children: notificationItems.map((item) {
        return Container(
          margin: EdgeInsets.only(bottom: height * 0.015),
          padding: EdgeInsets.all(width * 0.04),
          decoration: BoxDecoration(
            color: const Color(0xFF34AFB7),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              const Icon(Icons.notifications_active, color: Colors.white),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['message']!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item['time']!,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
