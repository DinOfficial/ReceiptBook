import 'package:flutter/material.dart';

class PersonsScreen extends StatefulWidget {
  const PersonsScreen({super.key, required this.title});
  final String title;

  @override
  State<PersonsScreen> createState() => _PersonsScreenState();
}

class _PersonsScreenState extends State<PersonsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title),),
    );
  }
}
