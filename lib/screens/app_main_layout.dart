import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:receipt_book/screens/add_new_screen.dart';
import 'package:receipt_book/screens/create_update_invoice_screen.dart';
import 'package:receipt_book/screens/home_screen.dart';
import 'package:receipt_book/screens/customerList_screen.dart';
import 'package:receipt_book/screens/settings_screen.dart';

class AppMainLayout extends StatefulWidget {
  const AppMainLayout({super.key});

  static String name = 'main-layout';

  @override
  State<AppMainLayout> createState() => _AppMainLayoutState();
}

class _AppMainLayoutState extends State<AppMainLayout> {
  int selectedIndex = 0;
  final List<Widget> pages = [
    HomeScreen(title: 'Home'),
    CreateUpdateInvoiceScreen(),
    CustomerListScreen(title: 'Customers'),
    SettingsScreen(title: 'Settings'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages.elementAt(selectedIndex),
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
                text: context.tr('main_layout.home'),
                iconSize: 28,
                iconColor: selectedIndex == 0 ? Colors.black87 : Colors.white54,
                gap: 2,
              ),
              GButton(
                icon: Icons.add,
                text: context.tr('main_layout.add_new'),
                iconSize: 28,
                iconColor: selectedIndex == 1 ? Colors.black87 : Colors.white54,
                gap: 2,
              ),
              GButton(
                icon: Icons.person,
                text: context.tr('main_layout.persons'),
                iconSize: 28,
                iconColor: selectedIndex == 2 ? Colors.black87 : Colors.white54,
                gap: 2,
              ),
              GButton(
                icon: Icons.settings,
                text: context.tr('main_layout.settings'),
                iconSize: 28,
                iconColor: selectedIndex == 3 ? Colors.black87 : Colors.white54,
                gap: 2,
              ),
            ],
            selectedIndex: selectedIndex,
            onTabChange: (index) {
              setState(() {
                selectedIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }
}
