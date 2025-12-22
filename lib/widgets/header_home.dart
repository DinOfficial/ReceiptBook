import 'package:flutter/material.dart';
import 'package:receipt_book/widgets/summery_data.dart';

class HeaderHome extends StatelessWidget {
  const HeaderHome({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 240,
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
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
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