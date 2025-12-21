import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class WelcomeAppBar extends StatefulWidget implements  PreferredSizeWidget{
  const WelcomeAppBar({super.key});

  @override
  State<WelcomeAppBar> createState() => _WelcomeAppBarState();
  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _WelcomeAppBarState extends State<WelcomeAppBar> {
  String selectedValue = 'English';
  List<String> items = ['English', 'বাংলা', 'हिन्दी'];
  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 40),
          child: DropdownButton(
            icon: Padding(
              padding: const EdgeInsets.all(4),
              child: HugeIcon(icon: HugeIcons.strokeRoundedInternet, size: 20),
            ),
            value: selectedValue,
            items: items.map((value) {
              return DropdownMenuItem(value: value, child: Text(value));
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                selectedValue = newValue!;
              });
            },
          ),
        ),
      ],
    );
  }
}
