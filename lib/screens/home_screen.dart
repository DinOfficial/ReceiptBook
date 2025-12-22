import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hugeicons/hugeicons.dart';
import '../widgets/header_home.dart';
import '../widgets/transection_list_tile.dart';

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
            Expanded(
              child: ListView.separated(
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                itemCount: 20,
                itemBuilder: (context, index) => TransectionListTile(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
