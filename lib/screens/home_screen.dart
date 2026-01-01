import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:receipt_book/models/invoice_model.dart';
import 'package:receipt_book/provider/invoice_provider.dart';
import '../widgets/header_home.dart';
import '../widgets/transection_list_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title});

  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      // Handle user not logged in case
      return Scaffold(
        body: Center(
          child: Text("User not logged in"),
        ),
      );
    }
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: Column(
          children: [
            HeaderHome(title: widget.title),
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
                  return ListView.separated(
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    itemCount: invoices.length,
                    itemBuilder: (context, index) => TransectionListTile(invoice: invoices[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
