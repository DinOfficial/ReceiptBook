import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';
import 'package:receipt_book/provider/theme_mode_provider.dart';
import 'package:receipt_book/screens/company_setup_screen.dart';
import 'package:receipt_book/screens/invoice_settings_screen.dart';
import 'package:receipt_book/screens/terms_of_service_screen.dart';
import 'package:receipt_book/screens/data_privacy_screen.dart';
import 'package:receipt_book/screens/share_app_screen.dart';
import 'package:receipt_book/screens/app_and_security_screen.dart';
import 'package:receipt_book/screens/welcome_screen.dart';
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
                                  provider.setThemeMode(value);
                                  ThemeSwitcher.of(
                                    context,
                                  ).changeTheme(theme: AppThemeStyle.lightTheme, isReversed: false);
                                }
                                Navigator.pop(context);
                              },
                            ),
                            RadioListTile<ThemeMode>(
                              title: const Text('Dark Mode'),
                              value: ThemeMode.dark,
                              groupValue: provider.themeMode,
                              onChanged: (ThemeMode? value) {
                                if (value != null) {
                                  provider.setThemeMode(value);
                                  ThemeSwitcher.of(
                                    context,
                                  ).changeTheme(theme: AppThemeStyle.darkTheme, isReversed: false);
                                }
                                Navigator.pop(context);
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

                                  final brightness = MediaQuery.of(context).platformBrightness;
                                  final theme = brightness == Brightness.dark
                                      ? AppThemeStyle.darkTheme
                                      : AppThemeStyle.lightTheme;

                                  ThemeSwitcher.of(context).changeTheme(theme: theme);

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
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            onTap: () {
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
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            tileColor: Colors.redAccent[200],
            onTap: () {
              FirebaseAuth.instance.signOut();
              GoogleSignIn().signOut();
              Navigator.pushNamedAndRemoveUntil(context, WelcomeScreen.name, (route) => false);
            },
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            leading: HugeIcon(icon: HugeIcons.strokeRoundedLogout03, size: 32),
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
