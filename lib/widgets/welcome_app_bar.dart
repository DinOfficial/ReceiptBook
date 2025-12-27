import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';
import 'package:receipt_book/provider/common_provider.dart';

import '../provider/theme_mode_provider.dart';

class WelcomeAppBar extends StatefulWidget implements PreferredSizeWidget {
  const WelcomeAppBar({super.key});

  @override
  State<WelcomeAppBar> createState() => _WelcomeAppBarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _WelcomeAppBarState extends State<WelcomeAppBar> {
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
    return AppBar(
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: Consumer<ThemeModeProvider>(
            builder: (context, themeProvider, _) {
              return Switch(
                value: themeProvider.themeMode == ThemeMode.dark,
                thumbIcon: thumbIcon,
                onChanged: (bool value) {
                  themeProvider.toggleThemeMode(value);
                },
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 40),
          child: Consumer<WelcomeScreenProvider>(
            builder: (context, welcomeAppBarProvider, _) {
              return DropdownButton(
                icon: Padding(
                  padding: const EdgeInsets.all(4),
                  child: HugeIcon(icon: HugeIcons.strokeRoundedInternet, size: 20),
                ),
                value: welcomeAppBarProvider.selectedValue,
                items: welcomeAppBarProvider.menuItemList.map((value) {
                  return DropdownMenuItem(value: value, child: Text(value));
                }).toList(),
                onChanged: welcomeAppBarProvider.onChangeMenu,
              );
            },
          ),
        ),
      ],
    );
  }
}
