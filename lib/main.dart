import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:receipt_book/app.dart';
import 'package:receipt_book/provider/auth_check_provider.dart';
import 'package:receipt_book/provider/common_provider.dart';
import 'package:receipt_book/provider/company_provider.dart';
import 'package:receipt_book/provider/customer_provider.dart';
import 'package:receipt_book/provider/invoice_provider.dart';
import 'package:receipt_book/provider/item_provider.dart';
import 'package:receipt_book/provider/log_out_provider.dart';
import 'package:receipt_book/provider/login_provider.dart';
import 'package:receipt_book/provider/theme_mode_provider.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WelcomeScreenProvider()),
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => LogOutProvider()),
        ChangeNotifierProvider(create: (_) => AuthCheckProvider()),
        ChangeNotifierProvider(create: (_) => PasswordTogglerProvider()),
        ChangeNotifierProvider(create: (_) => CompanyProvider()),
        ChangeNotifierProvider(create: (_) => ThemeModeProvider()),
        ChangeNotifierProvider(create: (_) => CustomerProvider()),
        ChangeNotifierProvider(create: (_) => ItemProvider()),
        ChangeNotifierProvider(create: (_) => InvoiceProvider()),

      ],
      child: ReceiptBookApp(),
    ),
  );
}
