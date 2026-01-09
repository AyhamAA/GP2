import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:test_app/screens/Admin/admin_profile_screen.dart';
import 'package:test_app/screens/Admin/analysis_screen.dart';
import 'package:test_app/screens/Admin/calendar_screen.dart';
import 'package:test_app/screens/Admin/admin_home_screen.dart';

class AdminNavigationpage extends StatefulWidget {
  const AdminNavigationpage({super.key});

  @override
  State<AdminNavigationpage> createState() => _AdminNavigationpageState();
}

class _AdminNavigationpageState extends State<AdminNavigationpage> {
  int _selectedindex=0;
  List<Widget> pages = [
    AdminHomeScreen(),
    CalendarScreen(),
    AnalysisScreen(),
    AdminProfileScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: pages[_selectedindex],
      bottomNavigationBar: Container(
        color: Color(0xFF1E5266),
        child: Padding(padding: EdgeInsets.all(8.6),
        child: GNav(
          iconSize: 26,
          //backgroundColor: Color(0xFFFFCE41),
          color: Colors.white,
          activeColor: Colors.white,
          tabBackgroundColor: Color(0xFF278389),

          selectedIndex: _selectedindex,
            onTabChange: (index) {
              setState(() {
                _selectedindex = index;
              });
            },
          
          
          tabs: const [
            GButton(
            icon: Icons.home_outlined,
            text: " Home",
            padding: EdgeInsets.symmetric(vertical: 18, horizontal: 18),
            textStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white 
            ),
            ),
            GButton(
            icon: Icons.calendar_month_outlined,
            text: " Calendar",
            padding: EdgeInsets.symmetric(vertical: 18, horizontal: 18),
            textStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white 
            ),
            ),
            GButton(
            icon: Icons.description_outlined,
            text: " Analysis",
            padding: EdgeInsets.symmetric(vertical: 18, horizontal: 18),
            textStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white 
            ),
            ),
            GButton(
            icon: Icons.person_2_outlined,
            text: " Profile",
            padding: EdgeInsets.symmetric(vertical: 18, horizontal: 18),
            textStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white 
            ),
            )
          ],
        
          ),
        
        ),
        
      ),
    );
  }
}