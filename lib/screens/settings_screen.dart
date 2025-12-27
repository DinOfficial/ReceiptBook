import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';
import 'package:receipt_book/provider/theme_mode_provider.dart';
import 'package:receipt_book/services/app_theme_style.dart';
import 'package:receipt_book/widgets/main_app_bar.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key, required this.title});

  final String title;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final WidgetStateProperty<Icon?> thumbIcon = WidgetStateProperty.resolveWith<Icon?>((
    Set<WidgetState> states,
  ) {
    if (states.contains(WidgetState.selected)) {
      return const Icon(Icons.nights_stay, color: Colors.black87);
    }
    return const Icon(Icons.wb_sunny, color: Colors.orange);
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeModeProvider>(context);
    return Scaffold(
      appBar: MainAppBar(title: 'Settings'),
      body: ListView(
        padding: EdgeInsets.only(top: 24, left: 12, right: 12, bottom: 20),
        children: [
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            onTap: () {},
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Color(0xff2692ce), width: 1.5),
            ),
            leading: HugeIcon(icon: HugeIcons.strokeRoundedSun02, size: 32),
            title: Text('Change apps mode', style: TextStyle(fontSize: 20)),
            trailing: Switch(
              value: themeProvider.themeMode == ThemeMode.dark,
              thumbIcon: thumbIcon,
              onChanged: (bool value) {
                themeProvider.toggleThemeMode(value);
              },
            ),
          ),
          const SizedBox(height: 20),
          ListTile(
            onTap: () {},
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Color(0xff2692ce), width: 1.5),
            ),
            leading: HugeIcon(icon: HugeIcons.strokeRoundedBriefcase06, size: 32),
            title: Text('Business Information', style: TextStyle(fontSize: 20)),
            subtitle: Text('Update | complete your company information'),
            trailing: HugeIcon(icon: HugeIcons.strokeRoundedArrowRightDouble),
          ),
          const SizedBox(height: 20),
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            onTap: () {},
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Color(0xff2692ce), width: 1.5),
            ),
            leading: HugeIcon(icon: HugeIcons.strokeRoundedPrinter, size: 32),
            title: Text('Invoice settings', style: TextStyle(fontSize: 20)),
            subtitle: Text('Choose your invoice template'),
            trailing: HugeIcon(icon: HugeIcons.strokeRoundedArrowRightDouble),
          ),
          const SizedBox(height: 20),
          ListTile(
            onTap: () {},
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Color(0xff2692ce), width: 1.5),
            ),
            leading: HugeIcon(icon: HugeIcons.strokeRoundedShieldUser, size: 32),
            title: Text('App & Security', style: TextStyle(fontSize: 20)),
            subtitle: Text('Know your terms and condition and data security'),
            trailing: HugeIcon(icon: HugeIcons.strokeRoundedArrowRightDouble),
          ),
          const SizedBox(height: 20),
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            onTap: () {},
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Color(0xff2692ce), width: 1.5),
            ),
            leading: HugeIcon(icon: HugeIcons.strokeRoundedCustomerService02, size: 32),
            title: Text('Get support', style: TextStyle(fontSize: 20)),
            subtitle: Text('Let us know what you\'r in trouble'),
            trailing: HugeIcon(icon: HugeIcons.strokeRoundedArrowRightDouble),
          ),
          const SizedBox(height: 20),
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            onTap: () {},
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Color(0xff2692ce), width: 1.5),
            ),
            leading: HugeIcon(icon: HugeIcons.strokeRoundedInformationDiamond, size: 32),
            title: Text('Who we are', style: TextStyle(fontSize: 20)),
            subtitle: Text('Know about our developer'),
            trailing: HugeIcon(icon: HugeIcons.strokeRoundedArrowRightDouble),
          ),
          const SizedBox(height: 20),
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            onTap: () {},
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Color(0xff2692ce), width: 1.5),
            ),
            leading: HugeIcon(icon: HugeIcons.strokeRoundedShare08, size: 32),
            title: Text('Share this app ', style: TextStyle(fontSize: 20)),
            subtitle: Text('If you enjoy it share with your friends'),
            trailing: HugeIcon(icon: HugeIcons.strokeRoundedArrowRightDouble),
          ),
          const SizedBox(height: 50),
          Center(
            child: Text('App Version: 1.1.1', style: TextStyle(color: Colors.grey, fontSize: 16)),
          ),
        ],
      ),
    );
  }
}
