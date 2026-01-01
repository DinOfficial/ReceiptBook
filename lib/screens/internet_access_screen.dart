import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:hugeicons/styles/stroke_rounded.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:receipt_book/screens/splash_screen.dart';

class InternetAccessScreen extends StatefulWidget {
  const InternetAccessScreen({super.key});

  static final String name = 'internet-access';

  @override
  State<InternetAccessScreen> createState() => _InternetAccessScreenState();
}

class _InternetAccessScreenState extends State<InternetAccessScreen> {
  late final StreamSubscription<InternetStatus> _internetSubscription;

  @override
  void initState() {
    super.initState();
    _internetSubscription =
        InternetConnection().onStatusChange.listen((InternetStatus status) {
      if (status == InternetStatus.connected) {
        if (mounted) {
          Navigator.pushNamedAndRemoveUntil(
              context, SplashScreen.name, (p) => false);
        }
      }
    });
  }

  @override
  void dispose() {
    _internetSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Internet Access')),
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          crossAxisAlignment: .center,
          children: [
            HugeIcon(icon: HugeIconsStrokeRounded.strokeRoundedWifiDisconnected03, size: 120,color: Colors.red,),
            Text('No internet access !', style: TextStyle(fontSize: 24, color: Colors.red),),
          ],
        ),
      ),
    );
  }
}
