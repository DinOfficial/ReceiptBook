import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:hugeicons/styles/stroke_rounded.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:receipt_book/provider/auth_check_provider.dart';
import 'package:receipt_book/screens/splash_screen.dart';

class InternetAccessScreen extends StatefulWidget {
  const InternetAccessScreen({super.key});

  static final String name = 'internet-access';

  @override
  State<InternetAccessScreen> createState() => _InternetAccessScreenState();
}

class _InternetAccessScreenState extends State<InternetAccessScreen> {
  @override
  void initState() {
    super.initState();
    InternetConnection().onStatusChange.listen((InternetStatus status) {
      if (status == InternetStatus.connected) {
        Navigator.pushNamedAndRemoveUntil(context, SplashScreen.name, (p) => false);
      } else {
        Navigator.pushNamedAndRemoveUntil(context, InternetAccessScreen.name, (p) => false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Internet Access')),
      body: Center(
        child: HugeIcon(icon: HugeIconsStrokeRounded.strokeRoundedWifiDisconnected03, size: 68,)
      ),
    );
  }
}
