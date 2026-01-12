import 'package:easy_localization/easy_localization.dart';
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
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _WelcomeAppBarState extends State<WelcomeAppBar> {
  @override
  Widget build(BuildContext context) {
    Locale currentLang = context.locale;
    return AppBar(
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 40),
          child: Consumer<WelcomeScreenProvider>(
            builder: (context, welcomeAppBarProvider, _) {
              return DropdownButton<String>(
                underline: const SizedBox(),
                icon: Padding(
                  padding: const EdgeInsets.all(4),
                  child: HugeIcon(icon: HugeIcons.strokeRoundedInternet, size: 20),
                ),
                value: currentLang.languageCode,
                items: welcomeAppBarProvider.menuItemList.map((value) {
                  return DropdownMenuItem<String>(value: value['code'], child: Text(value['name']));
                }).toList(),
                onChanged: (String? newValue) async {
                  if (newValue != null && newValue != currentLang.languageCode) {
                    await context.setLocale(Locale(newValue));
                    if (mounted) {
                      setState(() {});
                    }
                  }
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
