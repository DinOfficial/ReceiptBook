import 'package:easy_localization/easy_localization.dart' as context;
import 'package:flutter/material.dart';
import 'package:receipt_book/models/customer_model.dart';
import 'package:receipt_book/models/invoice_model.dart';
import 'package:receipt_book/widgets/transection_list_tile.dart';

/// Search delegate for invoices
class InvoiceSearchDelegate extends SearchDelegate<InvoiceModel?> {
  final List<InvoiceModel> invoices;

  InvoiceSearchDelegate(this.invoices);

  @override
  String get searchFieldLabel => context.tr('search_delegate.search_invoices');

  @override
  ThemeData appBarTheme(BuildContext context) {
    final theme = Theme.of(context);
    return theme.copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xff2a8bdc),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(color: Colors.white70),
        border: InputBorder.none,
      ),
      textTheme: theme.textTheme.copyWith(
        titleLarge: TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear, color: Colors.white),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back, color: Colors.white),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    final results = invoices.where((invoice) {
      final queryLower = query.toLowerCase();
      return invoice.invoiceNo.toLowerCase().contains(queryLower) ||
          invoice.customerName.toLowerCase().contains(queryLower);
    }).toList();

    if (results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              context.tr('search_delegate.no_invoices_found'),
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.all(12),
      itemCount: results.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return TransectionListTile(invoice: results[index]);
      },
    );
  }
}

/// Search delegate for customers
class CustomerSearchDelegate extends SearchDelegate<CustomerModel?> {
  final List<CustomerModel> customers;

  CustomerSearchDelegate(this.customers);

  @override
  String get searchFieldLabel => context.tr('search_delegate.search_customers');

  @override
  ThemeData appBarTheme(BuildContext context) {
    final theme = Theme.of(context);
    return theme.copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xff2a8bdc),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(color: Colors.white70),
        border: InputBorder.none,
      ),
      textTheme: theme.textTheme.copyWith(
        titleLarge: TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear, color: Colors.white),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back, color: Colors.white),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    final results = customers.where((customer) {
      final queryLower = query.toLowerCase();
      return customer.name.toLowerCase().contains(queryLower) ||
          customer.phone.toLowerCase().contains(queryLower);
    }).toList();

    if (results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_search, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              context.tr('search_delegate.no_customers_found'),
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.all(12),
      itemCount: results.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final customer = results[index];
        return ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Color(0xff2692ce), width: 1.5),
          ),
          leading: CircleAvatar(
            child: Text(
              customer.name.isNotEmpty ? customer.name[0].toUpperCase() : 'C',
            ),
          ),
          title: Text(customer.name),
          subtitle: Text(
            '${customer.email}\n${customer.phone}\n${customer.address}',
          ),
          isThreeLine: true,
        );
      },
    );
  }
}
