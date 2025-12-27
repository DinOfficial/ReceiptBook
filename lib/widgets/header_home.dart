import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';
import 'package:receipt_book/provider/log_out_provider.dart';
import 'package:receipt_book/screens/welcome_screen.dart';
import 'package:receipt_book/widgets/summery_data.dart';

class HeaderHome extends StatefulWidget {
  const HeaderHome({super.key, required this.title});

  final String title;

  @override
  State<HeaderHome> createState() => _HeaderHomeState();
}

class _HeaderHomeState extends State<HeaderHome> {
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
    return Container(
      height: 250,
      width: double.infinity,
      padding: const EdgeInsets.only(top: 40, left: 12, right: 12, bottom: 12),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xff4fb6c2), Color(0xff2a8bdc)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: .spaceBetween,
            crossAxisAlignment: .center,
            children: [
              Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              Consumer<LogOutProvider>(
                builder: (context, logOutProvider, _) {
                  return IconButton(
                    onPressed: () {
                      logOutProvider.logOut();
                      Navigator.of(
                        context,
                      ).pushNamedAndRemoveUntil(WelcomeScreen.name, (p) => false);
                    },
                    icon: HugeIcon(
                      icon: HugeIcons.strokeRoundedLogout01,
                      color: Colors.white70,
                      size: 30,
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          const TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            dividerColor: Colors.transparent,
            tabs: [
              Tab(text: "THIS WEEK"),
              Tab(text: "THIS MONTH"),
              Tab(text: "LAST MONTH"),
            ],
          ),

          const SizedBox(height: 12),

          SizedBox(
            height: 80,
            child: TabBarView(
              children: [
                SummaryRow(issued: "41", paid: "27", overdue: "3"),
                SummaryRow(issued: "120", paid: "98", overdue: "7"),
                SummaryRow(issued: "300", paid: "260", overdue: "15"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
