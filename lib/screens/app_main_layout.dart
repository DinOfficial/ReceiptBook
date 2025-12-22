import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class AppMainLayout extends StatefulWidget {
  const AppMainLayout({super.key});

  static String name = 'main-layout';

  @override
  State<AppMainLayout> createState() => _AppMainLayoutState();
}

class _AppMainLayoutState extends State<AppMainLayout> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        height: 60,
        width: MediaQuery.of(context).size.width *.8,
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
          color:Color(0xff2692ce),
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black12,
            )
          ],
          borderRadius: BorderRadius.circular(28)
        ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: GNav(
          rippleColor: Colors.grey[300]!,
          hoverColor: Colors.grey[100]!,
          // gap: 8,
          activeColor: Colors.black,
          iconSize: 24,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          duration: Duration(milliseconds: 400),
          tabBackgroundColor: Colors.grey[100]!,
          color: Colors.black,
          tabs: [
            GButton(
              icon: Icons.home_filled,
              text: 'Home',
            ),
            GButton(
              icon: Icons.add,
              text: 'Add New',
            ),
            GButton(
              icon: Icons.person,
              text: 'Persons',
            ),
            GButton(
              icon: Icons.settings,
              text: 'Settings',
            ),

          ],
          selectedIndex: _selectedIndex,
          onTabChange: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ),
      )
    );
  }
}
