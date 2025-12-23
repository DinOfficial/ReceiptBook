import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TransectionListTile extends StatelessWidget {
  const TransectionListTile({
    super.key,
  });

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
          ),SlidableAction(
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
          ),SlidableAction(
            onPressed: (BuildContext context) {},
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            icon: Icons.edit_location_alt_outlined,
            label: 'Edit',
          ),
        ],
      ),
      child: ListTile(
        onTap: (){},
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Color(0xff2692ce), width: 1.5),
        ),
        leading: CircleAvatar(child: Text('D')),
        title: Text('Jhone Doe'),
        subtitle: Text('20-Jan-2025'),
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
              '2,600 BDT',
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