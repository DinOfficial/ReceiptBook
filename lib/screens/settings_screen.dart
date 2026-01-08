import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';
import 'package:receipt_book/provider/theme_mode_provider.dart';
import 'package:receipt_book/screens/company_setup_screen.dart';
import 'package:receipt_book/screens/invoice_settings_screen.dart';
import 'package:receipt_book/screens/terms_of_service_screen.dart';
import 'package:receipt_book/screens/data_privacy_screen.dart';
import 'package:receipt_book/screens/share_app_screen.dart';
import 'package:receipt_book/services/app_theme_style.dart';
import 'package:receipt_book/screens/app_and_security_screen.dart';
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
    String getCurrentThemeText(ThemeMode themeMode) {
      switch (themeMode) {
        case ThemeMode.light:
          return 'light Mode';
        case ThemeMode.dark:
          return 'Dark';
        case ThemeMode.system:
          return 'System Default';
      }
    }

    return Scaffold(
      appBar: MainAppBar(title: 'Settings'),
      body: ListView(
        padding: EdgeInsets.only(top: 24, left: 12, right: 12, bottom: 20),
        children: [
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Color(0xff2692ce), width: 1.5),
            ),
            leading: HugeIcon(icon: HugeIcons.strokeRoundedSun02, size: 32),
            title: Text('App Theme', style: TextStyle(fontSize: 16)),
            subtitle: Text(getCurrentThemeText(themeProvider.themeMode)),
            trailing: HugeIcon(icon: HugeIcons.strokeRoundedMoreVerticalCircle02, size: 28),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Consumer<ThemeModeProvider>(
                    builder: (context, provider, child) {
                      return AlertDialog(
                        title: Text('Choose App Theme'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            RadioListTile<ThemeMode>(
                              title: const Text('Light Mode'),
                              value: ThemeMode.light,
                              groupValue: provider.themeMode,
                              onChanged: (ThemeMode? value) {
                                if (value != null) {
                                  // Provider-কে কল করে থিম পরিবর্তন করা হচ্ছে
                                  provider.setThemeMode(value);
                                  Navigator.pop(context); // ডায়ালগ বন্ধ করা হচ্ছে
                                }
                              },
                            ),
                            RadioListTile<ThemeMode>(
                              title: const Text('Dark Mode'),
                              value: ThemeMode.dark,
                              groupValue: provider.themeMode,
                              onChanged: (ThemeMode? value) {
                                if (value != null) {
                                  provider.setThemeMode(value);
                                  Navigator.pop(context);
                                }
                              },
                            ),
                            RadioListTile<ThemeMode>(
                              title: const Text('System Default'),
                              subtitle: const Text('Follows device settings'),
                              value: ThemeMode.system,
                              groupValue: provider.themeMode,
                              onChanged: (ThemeMode? value) {
                                if (value != null) {
                                  provider.setThemeMode(value);
                                  Navigator.pop(context);
                                }
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
          // =================== বাকি ListTile অপরিবর্তিত থাকবে ===================

          const SizedBox(height: 20),
          ListTile(
            onTap: () {
              Navigator.pushNamed(context, CompanySetupScreen.name);
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Color(0xff2692ce), width: 1.5),
            ),
            leading: HugeIcon(icon: HugeIcons.strokeRoundedBriefcase06, size: 32),
            title: Text('Business Information', style: TextStyle(fontSize: 16)),
            subtitle: Text('Update | complete your company information'),
            trailing: HugeIcon(icon: HugeIcons.strokeRoundedArrowRightDouble),
          ),
          const SizedBox(height: 16),
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            onTap: () {
              Navigator.pushNamed(context, InvoiceSettingsScreen.name);
            },
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

          // Biometric option moved to App & Security
          const SizedBox(height: 20),
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            onTap: () {
              // Assuming AppAndSecurityScreen contains Terms/Privacy links, or we link them directly here?
              // The request said "in setting page...". I'll link specific tiles if they exist or create new ones?
              // The existing list has "App & Security". Let's assume that screen has the details.
              // BUT I also created standalone screens. Let's make the "App & Security" tile go to a screen that lists these?
              // Or simpler: I will assume the user wants them accessible.
              // The UI has "Get support", "Who we are" etc.
              // I will link "Share this app" to ShareAppScreen.

              // Wait, I previously tried to add tiles for Terms/Privacy directly in the settings list.
              // Let's stick to the existing tiles but create new ones if needed or reuse.
              // Actually the user said "in setting page terms and condition...".
              // The code I saw in step 89 has "App & Security" tile.
              // I will ADD the Terms and Privacy tiles to the main settings list as per my previous failed attempt, but cleaner.
              Navigator.pushNamed(context, AppAndSecurityScreen.name);
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Color(0xff2692ce), width: 1.5),
            ),
            leading: HugeIcon(icon: HugeIcons.strokeRoundedShieldUser, size: 32),
            title: Text('App & Security', style: TextStyle(fontSize: 20)),
            subtitle: Text('Terms, Conditions & Privacy'),
            trailing: HugeIcon(icon: HugeIcons.strokeRoundedArrowRightDouble),
          ),
          const SizedBox(height: 20),
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            onTap: () {
              Navigator.pushNamed(context, TermsOfServiceScreen.name);
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Color(0xff2692ce), width: 1.5),
            ),
            leading: HugeIcon(icon: HugeIcons.strokeRoundedGoogleDoc, size: 32),
            title: Text('Terms & Conditions', style: TextStyle(fontSize: 20)),
            subtitle: Text('Read our terms'),
            trailing: HugeIcon(icon: HugeIcons.strokeRoundedArrowRightDouble),
          ),
          const SizedBox(height: 20),
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            onTap: () {
              Navigator.pushNamed(context, DataPrivacyScreen.name);
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Color(0xff2692ce), width: 1.5),
            ),
            leading: HugeIcon(icon: HugeIcons.strokeRoundedSecurityCheck, size: 32),
            title: Text('Data Privacy', style: TextStyle(fontSize: 20)),
            subtitle: Text('How we use your data'),
            trailing: HugeIcon(icon: HugeIcons.strokeRoundedArrowRightDouble),
          ),
          const SizedBox(height: 20),
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            onTap: () {
              Navigator.pushNamed(context, ShareAppScreen.name);
            },
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
