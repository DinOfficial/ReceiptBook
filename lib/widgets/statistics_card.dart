import 'package:flutter/material.dart';
import 'package:receipt_book/widgets/search_delegates.dart';

import '../models/invoice_model.dart';

class StatisticsCard extends StatelessWidget {
  const StatisticsCard({
    super.key,
    required this.invoices,
    required this.totalInvoices,
    required this.totalAmount,
    required this.paidCount,
    required this.sentCount,
    required this.draftCount,
  });

  final List<InvoiceModel> invoices;
  final int totalInvoices;
  final double totalAmount;
  final int paidCount;
  final int sentCount;
  final int draftCount;

  @override
  Widget build(BuildContext context) {
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
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.search, color: Colors.white, size: 28),
                onPressed: () {
                  showSearch(context: context, delegate: InvoiceSearchDelegate(invoices));
                },
              ),
            ],
          ),
          const SizedBox(height: 4),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: _StatCard(
                    title: 'Total',
                    value: totalInvoices.toString(),
                    icon: Icons.receipt_long,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 3,
                  child: _StatCard(
                    title: 'Amount',
                    value: '৳ ${totalAmount.toStringAsFixed(0)}',
                    icon: Icons.attach_money,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: _StatCard(
                    title: 'Paid',
                    value: paidCount.toString(),
                    icon: Icons.check_circle,
                    color: Colors.green.shade100,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: _StatCard(
                    title: 'Sent',
                    value: sentCount.toString(),
                    icon: Icons.send,
                    color: Colors.orange.shade100,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: _StatCard(
                    title: 'Draft',
                    value: draftCount.toString(),
                    icon: Icons.drafts,
                    color: Colors.grey.shade200,
                  ),
                ),
              ],
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

  const _StatCard({required this.title, required this.value, required this.icon, this.color});

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
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xff2a8bdc)),
          ),
          Text(title, style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
        ],
      ),
    );
  }
}
