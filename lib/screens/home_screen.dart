import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:receipt_book/models/invoice_model.dart';
import 'package:receipt_book/provider/auth_check_provider.dart';
import 'package:receipt_book/provider/invoice_provider.dart';
import 'package:receipt_book/widgets/main_app_bar.dart';
import 'package:receipt_book/widgets/search_delegates.dart';
import '../widgets/header_home.dart';
import '../widgets/statistics_card.dart';
import '../widgets/transection_list_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title});

  final String title;
  static final String name = 'home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      AuthCheckProvider().authCheckAndRedirection(context);
      return Scaffold(body: Center(child: Text(context.tr('home_screen.user_not_logged'))));
    }
    return Scaffold(
      appBar: MainAppBar(title: context.tr('main_layout.home')),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<InvoiceModel>>(
              stream: context.read<InvoiceProvider>().getAllInvoices(uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text(context.tr('home_screen.no_invoices')));
                }

                final invoices = snapshot.data!;

                // Calculate statistics
                final totalInvoices = invoices.length;
                final totalAmount = invoices.fold<double>(0, (sum, inv) => sum + inv.total);
                final paidCount = invoices.where((inv) => inv.status == 'Paid').length;
                final draftCount = invoices.where((inv) => inv.status == 'Draft').length;
                final sentCount = invoices.where((inv) => inv.status == 'Sent').length;

                return ListView.separated(
                  padding: const EdgeInsets.only(bottom: 12),
                  itemCount: invoices.length + 1,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return StatisticsCard(
                        invoices: invoices,
                        totalInvoices: totalInvoices,
                        totalAmount: totalAmount,
                        paidCount: paidCount,
                        sentCount: sentCount,
                        draftCount: draftCount,
                      );
                    }
                    // Invoice List Items
                    final invoice = invoices[index - 1];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: TransectionListTile(invoice: invoice),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
