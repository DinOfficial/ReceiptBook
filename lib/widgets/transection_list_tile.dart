import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:receipt_book/models/invoice_model.dart';

class TransectionListTile extends StatelessWidget {
  const TransectionListTile({
    super.key,
    required this.invoice,
  });

  final InvoiceModel invoice;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      groupTag: 'my-list',
      startActionPane: ActionPane(
        motion: DrawerMotion(),
        dragDismissible: true,
        children: [
          SlidableAction(
            onPressed: (BuildContext context) {},
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete_outline_rounded,
            label: 'Delete',
          ),
          SlidableAction(
            onPressed: (BuildContext context) {},
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            icon: Icons.edit_location_alt_outlined,
            label: 'Edit',
          ),
        ],
      ),
      endActionPane: ActionPane(
        motion: DrawerMotion(),
        dragDismissible: true,
        children: [
          SlidableAction(
            onPressed: (BuildContext context) {},
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete_outline_rounded,
            label: 'Delete',
          ),
          SlidableAction(
            onPressed: (BuildContext context) {},
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            icon: Icons.edit_location_alt_outlined,
            label: 'Edit',
          ),
        ],
      ),
      child: ListTile(
        onTap: () {},
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Color(0xff2692ce), width: 1.5),
        ),
        leading: CircleAvatar(child: Text(invoice.customerName.isNotEmpty ? invoice.customerName[0] : 'N')),
        title: Text(invoice.customerName),
        subtitle: Text(DateFormat('dd-MMM-yyyy').format(invoice.date)),
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
              NumberFormat.currency(symbol: '', decimalDigits: 2).format(invoice.total) + ' BDT',
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
