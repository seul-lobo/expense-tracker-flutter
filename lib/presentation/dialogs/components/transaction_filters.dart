import 'package:flutter/material.dart';

class TransactionFilters extends StatelessWidget {
  const TransactionFilters({super.key});

  @override
  Widget build(BuildContext context) {
    final filters = ['Daily', 'Weekly', 'Monthly', 'Yearly'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: filters
          .map(
            (label) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Text(
                label,
                style: const TextStyle(
                  color: Color.fromARGB(255, 204, 195, 111),
                  fontSize: 17,
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
