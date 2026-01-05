import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';
import 'package:receipt_book/models/customer_model.dart';
import 'package:receipt_book/provider/customer_provider.dart';
import 'package:receipt_book/provider/invoice_provider.dart';
import 'package:receipt_book/screens/create_update_customer_screen.dart';
import 'package:receipt_book/widgets/main_app_bar.dart';
import 'package:receipt_book/widgets/search_delegates.dart';

class PersonsScreen extends StatefulWidget {
  const PersonsScreen({super.key, required this.title});

  final String title;

  @override
  State<PersonsScreen> createState() => _PersonsScreenState();
}

class _PersonsScreenState extends State<PersonsScreen> {
  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      return Scaffold(
        appBar: MainAppBar(title: 'Customers'),
        body: Center(child: Text('Please log in to view customers')),
      );
    }

    return Scaffold(
      appBar: MainAppBar(
        title: 'Customers',
        actions: [
          StreamBuilder<List<CustomerModel>>(
            stream: context.watch<CustomerProvider>().streamCustomers(uid),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return SizedBox.shrink();
              return IconButton(
                icon: Icon(Icons.search, color: Colors.white, size: 28),
                onPressed: () {
                  showSearch(
                    context: context,
                    delegate: CustomerSearchDelegate(snapshot.data!),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<List<CustomerModel>>(
        stream: context.watch<CustomerProvider>().streamCustomers(uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person_off, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No customers yet',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Add your first customer using the + button',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          final customers = snapshot.data!;

          return ListView.separated(
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            itemCount: customers.length,
            itemBuilder: (context, index) {
              final customer = customers[index];
              return Slidable(
                key: ValueKey(customer.id),
                groupTag: 'customer-list',
                startActionPane: ActionPane(
                  motion: DrawerMotion(),
                  dragDismissible: false,
                  children: [
                    SlidableAction(
                      onPressed: (BuildContext context) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Delete Customer?'),
                            content: Text(
                              'This will delete the customer AND ALL associated invoices. This action cannot be undone.',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  context
                                      .read<CustomerProvider>()
                                      .deleteCustomer(
                                        context,
                                        customer.id!,
                                        context.read<InvoiceProvider>(),
                                      );
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  'Delete',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      icon: Icons.delete_outline_rounded,
                      label: 'Delete',
                    ),
                    SlidableAction(
                      onPressed: (BuildContext context) {
                        Navigator.pushNamed(
                          context,
                          CreateUpdateCustomerScreen.name,
                          arguments: customer,
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
                  motion: DrawerMotion(),
                  dragDismissible: false,
                  children: [
                    SlidableAction(
                      onPressed: (BuildContext context) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Delete Customer?'),
                            content: Text(
                              'This will delete the customer AND ALL associated invoices. This action cannot be undone.',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context); // Close dialog
                                  context
                                      .read<CustomerProvider>()
                                      .deleteCustomer(
                                        context,
                                        customer.id!,
                                        context.read<InvoiceProvider>(),
                                      );
                                },
                                child: Text(
                                  'Delete',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      icon: Icons.delete_outline_rounded,
                      label: 'Delete',
                    ),
                    SlidableAction(
                      onPressed: (BuildContext context) {
                        Navigator.pushNamed(
                          context,
                          CreateUpdateCustomerScreen.name,
                          arguments: customer,
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
                  onTap: () {
                    // TODO: Show customer details
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: Color(0xff2692ce), width: 1.5),
                  ),
                  leading: CircleAvatar(
                    child: Text(
                      customer.name.isNotEmpty
                          ? customer.name[0].toUpperCase()
                          : 'C',
                    ),
                  ),
                  title: Text(customer.name),
                  subtitle: Text(
                    '${customer.email}\n${customer.phone}\n${customer.address}',
                  ),
                  isThreeLine: true,
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(38)),
        onPressed: () {
          Navigator.pushNamed(context, CreateUpdateCustomerScreen.name);
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff4fb6c2), Color(0xff2a8bdc)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(40),
            border: Border.all(color: Colors.white, width: 3),
          ),
          child: Center(
            child: HugeIcon(
              icon: HugeIcons.strokeRoundedPlusSignCircle,
              color: Colors.white,
              strokeWidth: 3,
            ),
          ),
        ),
      ),
    );
  }
}
