import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:receipt_book/models/invoice_model.dart';
import 'package:receipt_book/provider/auth_check_provider.dart';
import 'package:receipt_book/provider/invoice_provider.dart';
import 'package:receipt_book/widgets/main_app_bar.dart';
import 'package:receipt_book/widgets/search_delegates.dart';
import '../widgets/header_home.dart';
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
      return Scaffold(body: Center(child: Text("User not logged in")));
    }
    return Scaffold(
      appBar: MainAppBar(title: 'Home'),
      body: Column(
        children: [
          // HeaderHome(title: widget.title),
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
                  return Center(child: Text("No invoices found."));
                }

                final invoices = snapshot.data!;

                // Calculate statistics
                final totalInvoices = invoices.length;
                final totalAmount = invoices.fold<double>(
                  0,
                  (sum, inv) => sum + inv.total,
                );
                final paidCount = invoices
                    .where((inv) => inv.status == 'Paid')
                    .length;
                final draftCount = invoices
                    .where((inv) => inv.status == 'Draft')
                    .length;
                final sentCount = invoices
                    .where((inv) => inv.status == 'Sent')
                    .length;

                return ListView.separated(
                  padding: const EdgeInsets.only(bottom: 12),
                  itemCount: invoices.length + 1,
                  // itemCount: 1, // Debugging: Only show Statistics
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      // Statistics Section
                      return Container(
                        margin: const EdgeInsets.all(12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xff4fb6c2), Color(0xff2a8bdc)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Statistics',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.search,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                  onPressed: () {
                                    showSearch(
                                      context: context,
                                      delegate: InvoiceSearchDelegate(invoices),
                                    );
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  _StatCard(
                                    title: 'Total',
                                    value: totalInvoices.toString(),
                                    icon: Icons.receipt_long,
                                  ),
                                  const SizedBox(width: 12),
                                  _StatCard(
                                    title: 'Amount',
                                    value:
                                        '৳ ${totalAmount.toStringAsFixed(0)}',
                                    icon: Icons.attach_money,
                                  ),
                                  const SizedBox(width: 12),
                                  _StatCard(
                                    title: 'Paid',
                                    value: paidCount.toString(),
                                    icon: Icons.check_circle,
                                    color: Colors.green.shade100,
                                  ),
                                  const SizedBox(width: 12),
                                  _StatCard(
                                    title: 'Sent',
                                    value: sentCount.toString(),
                                    icon: Icons.send,
                                    color: Colors.orange.shade100,
                                  ),
                                  const SizedBox(width: 12),
                                  _StatCard(
                                    title: 'Draft',
                                    value: draftCount.toString(),
                                    icon: Icons.drafts,
                                    color: Colors.grey.shade200,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
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

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color? color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color ?? Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, size: 24, color: Color(0xff2a8bdc)),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xff2a8bdc),
            ),
          ),
          Text(
            title,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }
}
