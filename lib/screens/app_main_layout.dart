import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:receipt_book/screens/add_new_screen.dart';
import 'package:receipt_book/screens/home_screen.dart';
import 'package:receipt_book/screens/persons_screen.dart';
import 'package:receipt_book/screens/settings_screen.dart';

class AppMainLayout extends StatefulWidget {
  const AppMainLayout({super.key});

  static String name = 'main-layout';

  @override
  State<AppMainLayout> createState() => _AppMainLayoutState();
}

class _AppMainLayoutState extends State<AppMainLayout> {
  int _selectedIndex = 0;
  static final List<Widget> _pages = [
    HomeScreen(title: 'Home'),
    AddNewScreen(title: 'Add New'),
    PersonsScreen(title: 'Persons'),
    SettingsScreen(title: 'Settings'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages.elementAt(_selectedIndex),
      bottomNavigationBar: Container(
        height: 66,
        width: MediaQuery.of(context).size.width * .8,
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
          color: Color(0xff2692ce),
          boxShadow: [BoxShadow(blurRadius: 20, color: Colors.black12)],
          borderRadius: BorderRadius.circular(28),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: GNav(
            rippleColor: Colors.grey[300]!,
            hoverColor: Colors.grey[100]!,
            activeColor: Colors.black,
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            duration: Duration(milliseconds: 400),
            tabBackgroundColor: Colors.grey[100]!,
            color: Colors.black,
            tabs: <GButton>[
              GButton(
                icon: Icons.home,
                text: 'Home',
                iconSize: 28,
                iconColor: _selectedIndex == 0 ? Colors.black87 : Colors.white54,
                gap: 2,
              ),
              GButton(
                icon: Icons.add,
                text: 'Add New',
                iconSize: 28,
                iconColor: _selectedIndex == 1 ? Colors.black87 : Colors.white54,
                gap: 2,
              ),
              GButton(
                icon: Icons.person,
                text: 'Persons',
                iconSize: 28,
                iconColor: _selectedIndex == 2 ? Colors.black87 : Colors.white54,
                gap: 2,
              ),
              GButton(
                icon: Icons.settings,
                text: 'Settings',
                iconSize: 28,
                iconColor: _selectedIndex == 3 ? Colors.black87 : Colors.white54,
                gap: 2,
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
      ),
    );
  }
}
