import 'package:flutter/material.dart';

class RecurringCard extends StatelessWidget {
  final String title;
  final String periodTime;
  final VoidCallback onDelete;

  const RecurringCard({
    super.key,
    required this.title,
    required this.periodTime,
    required this.onDelete,
  });

  

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color(0xFF2C2C2E),
      ),
      child: Row(
        children: [
          // 📅 Recurring title and period
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  periodTime,
                  style: const TextStyle(color: Colors.white54, fontSize: 14),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onDelete,
            icon: const Icon(Icons.delete, color: Colors.redAccent),
          ),
        ],
      ),
    );
  }
}
