import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:receipt_book/models/invoice_model.dart';
import 'package:receipt_book/provider/invoice_provider.dart';
import 'package:receipt_book/screens/create_update_invoice_screen.dart';

import 'invoice_view.dart';

class TransectionListTile extends StatelessWidget {
  const TransectionListTile({super.key, required this.invoice});

  final InvoiceModel invoice;

  Future<void> _showDeleteConfirmation(
    BuildContext context,
    InvoiceModel invoice,
  ) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Invoice'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Are you sure you want to delete this invoice?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
              onPressed: () {
                final uid = FirebaseAuth.instance.currentUser?.uid;
                context.read<InvoiceProvider>().deleteInvoice(
                  context,
                  uid,
                  invoice.customerId,
                  invoice.invoiceId,
                );
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    void onTapInvoice() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => InvoiceView(invoice: invoice)),
      );
    }

    return Slidable(
      key: ValueKey(invoice.invoiceId),
      groupTag: 'my-list',
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        dragDismissible: true,
        children: [
          SlidableAction(
            onPressed: (BuildContext context) {
              _showDeleteConfirmation(context, invoice);
            },
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete_outline_rounded,
            label: 'Delete',
          ),
          SlidableAction(
            onPressed: (BuildContext context) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      CreateUpdateInvoiceScreen(invoice: invoice),
                ),
              );
            },
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            icon: Icons.edit_location_alt_outlined,
            label: 'Edit',
          ),
        ],
      ),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        dragDismissible: true,
        children: [
          SlidableAction(
            onPressed: (BuildContext context) {
              _showDeleteConfirmation(context, invoice);
            },
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete_outline_rounded,
            label: 'Delete',
          ),
          SlidableAction(
            onPressed: (BuildContext context) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      CreateUpdateInvoiceScreen(invoice: invoice),
                ),
              );
            },
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            icon: Icons.edit_location_alt_outlined,
            label: 'Edit',
          ),
        ],
      ),
      child: ListTile(
        onTap: onTapInvoice,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Color(0xff2692ce), width: 1.5),
        ),
        leading: CircleAvatar(
          child: Text(
            invoice.customerName.isNotEmpty ? invoice.customerName[0] : 'N',
          ),
        ),
        title: Text(invoice.customerName),
        subtitle: Text(
          DateFormat('dd-MMM-yyyy').format(invoice.date),
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey.shade400
                : Colors.grey.shade700,
          ),
        ),
        trailing: Container(
          height: 48,
          width: 120,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff4fb6c2), Color(0xff2a8bdc)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              NumberFormat.currency(
                symbol: '',
                decimalDigits: 2,
              ).format(invoice.total),
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
