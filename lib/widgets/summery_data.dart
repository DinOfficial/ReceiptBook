import 'package:flutter/material.dart';

class SummaryRow extends StatefulWidget {
  final String issued;
  final String paid;
  final String overdue;

  const SummaryRow({super.key,
    required this.issued,
    required this.paid,
    required this.overdue,
  });

  @override
  State<SummaryRow> createState() => SummaryRowState();
}

class SummaryRowState extends State<SummaryRow> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _Item(value: widget.issued, label: "Issued"),
        _Item(value: widget.paid, label: "Paid"),
        _Item(value: widget.overdue, label: "Overdue"),
      ],
    );
  }
}

class _Item extends StatelessWidget {
  final String value;
  final String label;

  const _Item({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: Colors.white70),
        ),
      ],
    );
  }
}

