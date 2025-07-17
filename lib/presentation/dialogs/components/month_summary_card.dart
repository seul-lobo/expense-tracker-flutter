import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/currency_entity.dart';
import '../../cubits/currency_cubit/currency_cubit.dart';
import '../../cubits/currency_cubit/currency_state.dart';
import '../../cubits/transaction_cubit/transaction_cubit.dart';

class MonthSummaryCard extends StatelessWidget {
  const MonthSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CurrencyCubit, CurrencyState>(
      builder: (context, currencyState) {
        String currencySymbol = '\$'; // Default fallback
        if (currencyState is CurrencyLoaded) {
          final selectedCurrency = currencyState.currencies.firstWhere(
            (currency) => currency.isSelected,
            orElse: () => currencyState.currencies.isNotEmpty
                ? currencyState.currencies[0]
                : CurrencyEntity(name: 'USD', symbol: '\$', isSelected: false),
          );
          currencySymbol = selectedCurrency.symbol;
        }

        return BlocBuilder<TransactionCubit, TransactionState>(
          builder: (context, state) {
            double income = 0;
            double expense = 0;

            if (state is TransactionLoaded) {
              final now = DateTime.now();
              for (var tx in state.transactions) {
                if (tx.dateTime.month == now.month &&
                    tx.dateTime.year == now.year) {
                  if (tx.type == 'Income') {
                    income += tx.amount;
                  } else if (tx.type == 'Expense') {
                    expense += tx.amount;
                  }
                }
              }
            }

            double screenWidth = MediaQuery.of(context).size.width;
            double cardWidth =
                screenWidth - 32; // Account for 16px padding on each side

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _buildSummaryTile(
                    context: context,
                    width: cardWidth,
                    color: Colors.green[100]!,
                    icon: Icons.arrow_upward,
                    iconColor: Colors.green,
                    label: "Income",
                    amount: income,
                    currencySymbol: currencySymbol,
                  ),
                  const SizedBox(height: 16),
                  _buildSummaryTile(
                    context: context,
                    width: cardWidth,
                    color: Colors.red[100]!,
                    icon: Icons.arrow_downward,
                    iconColor: Colors.red,
                    label: "Expense",
                    amount: expense,
                    currencySymbol: currencySymbol,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSummaryTile({
    required BuildContext context,
    required double width,
    required Color color,
    required IconData icon,
    required Color iconColor,
    required String label,
    required double amount,
    required String currencySymbol,
  }) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 35),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$currencySymbol ${amount.toStringAsFixed(2)}', // Added space
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: const TextStyle(color: Colors.black54, fontSize: 15),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
