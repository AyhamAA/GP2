import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:test_app/screens/dr_DonorandRequester/dr_cart_screen.dart';
import 'package:test_app/screens/dr_DonorandRequester/donor/donor_request_screen.dart';
import 'package:test_app/screens/dr_DonorandRequester/dr_home_screen.dart';
import 'package:test_app/screens/dr_DonorandRequester/dr_profile_screen.dart';


class DrNavigationpage extends StatefulWidget {
  const DrNavigationpage({super.key});

  @override
  State<DrNavigationpage> createState() => _DrNavigationpageState();
}

class _DrNavigationpageState extends State<DrNavigationpage> {
  int _selectedindex=0;
  List<Widget> pages = [
    DrHomeScreen(),
    DonorRequestScreen(),
    CartScreen(),
    DrProfileScreen(),
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
            icon: Icons.volunteer_activism_outlined,
            text: " Donor&Requster",
            padding: EdgeInsets.symmetric(vertical: 18, horizontal: 18),
            textStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white 
            ),
            ),
            GButton(
            icon: Icons.shopping_cart_outlined,
            text: " Cart",
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