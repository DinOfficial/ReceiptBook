import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';
import 'package:receipt_book/provider/common_provider.dart';
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

    Locale currentLang = context.locale;
    return Scaffold(
      appBar: MainAppBar(title: context.tr('settings_screen.settings')),
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
            title: Text(context.tr('settings_screen.app_theme'), style: TextStyle(fontSize: 16)),
            subtitle: Text(getCurrentThemeText(themeProvider.themeMode)),
            trailing: HugeIcon(icon: HugeIcons.strokeRoundedMoreVerticalCircle02, size: 28),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Consumer<ThemeModeProvider>(
                    builder: (context, provider, child) {
                      return AlertDialog(
                        title: Text(
                          context.tr('settings_screen.choose_theme'),
                          style: TextStyle(fontSize: 20),
                        ),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            RadioListTile<ThemeMode>(
                              title: Text(context.tr('settings_screen.light_mode')),
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
                              title: Text(context.tr('settings_screen.dark_mode')),
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
                              title: Text(context.tr('settings_screen.system_default')),
                              subtitle: Text(context.tr('settings_screen.follow_device_settings')),
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
                                }
                                Navigator.pop(context);
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
          Consumer<WelcomeScreenProvider>(
            builder: (context, provider, child) {
              return ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: Color(0xff2692ce), width: 1.5),
                ),
                leading: HugeIcon(icon: HugeIcons.strokeRoundedLanguageCircle, size: 32),
                title: Text(context.tr('settings_screen.app_lang'), style: TextStyle(fontSize: 16)),
                trailing: HugeIcon(icon: HugeIcons.strokeRoundedMoreVerticalCircle02, size: 28),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Consumer<ThemeModeProvider>(
                        builder: (context, provider, child) {
                          return AlertDialog(
                            title: Text(
                              context.tr('settings_screen.choose_theme'),
                              style: TextStyle(fontSize: 20),
                            ),
                            content: Consumer<WelcomeScreenProvider>(
                              builder: (context, welcomeAppBarProvider, _) {
                                return DropdownButton<String>(
                                  underline: const SizedBox(),
                                  icon: Padding(
                                    padding: const EdgeInsets.all(4),
                                    child: HugeIcon(
                                      icon: HugeIcons.strokeRoundedInternet,
                                      size: 20,
                                    ),
                                  ),
                                  value: currentLang.languageCode,
                                  items: welcomeAppBarProvider.menuItemList.map((value) {
                                    return DropdownMenuItem<String>(
                                      value: value['code'],
                                      child: Text(value['name']),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) async {
                                    if (newValue != null && newValue != currentLang.languageCode) {
                                      await context.setLocale(Locale(newValue));
                                      if (mounted) {
                                        Navigator.pop(context);
                                        setState(() {});
                                      }
                                    }
                                  },
                                );
                              },
                            ),
                          );
                        },
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
            title: Text(
              context.tr('settings_screen.business_information'),
              style: TextStyle(fontSize: 16),
            ),
            subtitle: Text(context.tr('settings_screen.subtitle')),
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
            title: Text(
              context.tr('settings_screen.invoice_settings'),
              style: TextStyle(fontSize: 20),
            ),
            subtitle: Text(context.tr('settings_screen.choose_invoice_template')),
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
            title: Text(
              context.tr('settings_screen.app_and_security'),
              style: TextStyle(fontSize: 20),
            ),
            subtitle: Text(context.tr('settings_screen.setup_app_security')),
            trailing: HugeIcon(icon: HugeIcons.strokeRoundedArrowRightDouble),
          ),
          const SizedBox(height: 20),
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            onTap: () {
              Navigator.pushNamed(context, TermsAndConditionsPage.name);
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Color(0xff2692ce), width: 1.5),
            ),
            leading: HugeIcon(icon: HugeIcons.strokeRoundedGoogleDoc, size: 32),
            title: Text(
              context.tr('settings_screen.terms_and_conditions'),
              style: TextStyle(fontSize: 20),
            ),
            subtitle: Text(context.tr('settings_screen.read_our_terms')),
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
            title: Text(context.tr('settings_screen.data_privacy'), style: TextStyle(fontSize: 20)),
            subtitle: Text(context.tr('settings_screen.how_we_use_your_data')),
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
            title: Text(
              context.tr('settings_screen.share_this_app'),
              style: TextStyle(fontSize: 20),
            ),
            subtitle: Text(context.tr('settings_screen.if_enjoy')),
            trailing: HugeIcon(icon: HugeIcons.strokeRoundedArrowRightDouble),
          ),
          const SizedBox(height: 40),
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            tileColor: Colors.redAccent,
            onTap: () {
              FirebaseAuth.instance.signOut();
              GoogleSignIn().signOut();
              Navigator.pushNamedAndRemoveUntil(context, WelcomeScreen.name, (p) => false);
            },
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            leading: HugeIcon(icon: HugeIcons.strokeRoundedLogout01, size: 32, color: Colors.white),
            title: Text(
              context.tr('settings_screen.logout'),
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
          const SizedBox(height: 50),
          Center(
            child: Text('App Version: 1.1.1', style: TextStyle(color: Colors.grey, fontSize: 16)),
          ),
          const SizedBox(height: 40),
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            tileColor: Colors.redAccent[100],
            onTap: () {
              showDialog(
                context: context,
                barrierDismissible: true,
                builder: (context) => AlertDialog(
                  title: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      HugeIcon(icon: HugeIcons.strokeRoundedUser, color: Colors.red,size: 40,),
                      const SizedBox(width: 12),
                      Text(
                        'Account Deletion\n'
                        'Confirmation', style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(
                        child: Text(
                          'After delete your account you will  lost your account and data ', style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(context.tr('customer_list_screen.cancel')),
                    ),
                    TextButton(onPressed: () {}, child: Text(context.tr('Yes ! Delete'), style: TextStyle(color: Colors.red),)),
                  ],
                ),
              );
            },
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            leading: HugeIcon(
              icon: HugeIcons.strokeRoundedUserWarning02,
              size: 32,
              color: Colors.white,
            ),
            title: Text(
              context.tr('settings_screen.delete_acc'),
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
