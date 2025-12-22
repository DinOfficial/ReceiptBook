import 'package:flutter/material.dart';
import '../widgets/header_home.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: Column(
          children: [
            HeaderHome(title: title),
            Expanded(child: Center(child: Text("Below Content"))),
          ],
        ),
      ),
    );
  }
}
