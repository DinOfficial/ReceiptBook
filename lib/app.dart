import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:receipt_book/models/customer_model.dart';
import 'package:receipt_book/provider/theme_mode_provider.dart';
import 'package:receipt_book/screens/app_main_layout.dart';
import 'package:receipt_book/screens/auth/confirm_email_verification.dart';
import 'package:receipt_book/screens/auth/forgot_email_screen.dart';
import 'package:receipt_book/screens/auth/log_in_screen.dart';
import 'package:receipt_book/screens/auth/register_screen.dart';
import 'package:receipt_book/screens/company_setup_screen.dart';
import 'package:receipt_book/screens/create_update_customer_screen.dart';
import 'package:receipt_book/screens/create_update_invoice_screen.dart';
import 'package:receipt_book/screens/internet_access_screen.dart';
import 'package:receipt_book/screens/invoice_settings_screen.dart';
import 'package:receipt_book/screens/app_and_security_screen.dart';
import 'package:receipt_book/screens/splash_screen.dart';
import 'package:receipt_book/screens/welcome_screen.dart';
import 'package:receipt_book/services/app_theme_style.dart';
import 'package:receipt_book/screens/terms_of_service_screen.dart';
import 'package:receipt_book/screens/data_privacy_screen.dart';
import 'package:receipt_book/screens/share_app_screen.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';

class ReceiptBookApp extends StatelessWidget {
  const ReceiptBookApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeModeProvider>();
    return ThemeProvider(
      initTheme: themeProvider.themeMode == ThemeMode.dark
          ? AppThemeStyle.darkTheme
          : AppThemeStyle.lightTheme,
      builder: (context, theme) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppThemeStyle.lightTheme,
          darkTheme: AppThemeStyle.darkTheme,
          themeMode: themeProvider.themeMode,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          initialRoute: SplashScreen.name,
          routes: {
            SplashScreen.name: (_) => SplashScreen(),
            WelcomeScreen.name: (_) => WelcomeScreen(),
            RegistrationScreen.name: (_) => RegistrationScreen(),
            ConfirmEmailVerification.name: (_) => ConfirmEmailVerification(),
            LoginScreen.name: (_) => LoginScreen(),
            ForgotEmailScreen.name: (_) => ForgotEmailScreen(),
            AppMainLayout.name: (_) => AppMainLayout(),
            CompanySetupScreen.name: (_) => CompanySetupScreen(),
            CreateUpdateCustomerScreen.name: (context) {
              final customer = ModalRoute.of(context)?.settings.arguments as CustomerModel?;
              return CreateUpdateCustomerScreen(customer: customer);
            },
            CreateUpdateInvoiceScreen.name: (_) => CreateUpdateInvoiceScreen(),
            InternetAccessScreen.name: (_) => InternetAccessScreen(),
            InvoiceSettingsScreen.name: (_) => InvoiceSettingsScreen(),
            AppAndSecurityScreen.name: (_) => AppAndSecurityScreen(),
            TermsAndConditionsPage.name: (_) => TermsAndConditionsPage(),
            DataPrivacyScreen.name: (_) => DataPrivacyScreen(),
            ShareAppScreen.name: (_) => ShareAppScreen(),
          },
        );
      },
    );
  }
}
