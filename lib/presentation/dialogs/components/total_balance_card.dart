import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/account_entity.dart';
import '../../../domain/entities/currency_entity.dart';
import '../../cubits/account_cubit/account_cubit.dart';
import '../../cubits/currency_cubit/currency_cubit.dart';
import '../../cubits/currency_cubit/currency_state.dart';
import '../../cubits/transaction_cubit/transaction_cubit.dart';

class TotalBalanceCard extends StatelessWidget {
  const TotalBalanceCard({super.key});

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

        return BlocBuilder<AccountCubit, AccountState>(
          builder: (context, accountState) {
            return BlocBuilder<TransactionCubit, TransactionState>(
              builder: (context, txState) {
                double totalBalance = 0;
                List<AccountEntity> userAccounts = [];
                double recentIncome = 0;
                double recentExpense = 0;

                if (accountState is AccountLoaded) {
                  userAccounts = accountState.accounts;
                  totalBalance = userAccounts.fold(
                    0.0,
                    (sum, acc) => sum + acc.balance,
                  );
                }

                if (txState is TransactionLoaded) {
                  final txs = txState.transactions;

                  // Find latest income and expense
                  final latestIncome =
                      txs.where((tx) => tx.type == 'Income').toList()
                        ..sort((a, b) => b.dateTime.compareTo(a.dateTime));

                  final latestExpense =
                      txs.where((tx) => tx.type == 'Expense').toList()
                        ..sort((a, b) => b.dateTime.compareTo(a.dateTime));

                  if (latestIncome.isNotEmpty) {
                    recentIncome = latestIncome.first.amount;
                  }

                  if (latestExpense.isNotEmpty) {
                    recentExpense = latestExpense.first.amount;
                  }
                }

                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        const Color(0xFFEFD56F).withOpacity(0.9),
                        Colors.black.withOpacity(0.7),
                      ],
                      stops: const [0.0, 1.0],
                      tileMode: TileMode.clamp,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Total Balance',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '$currencySymbol ${totalBalance.toStringAsFixed(2)}', // Added space
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildAmountColumn(
                            "+ $currencySymbol ${recentIncome.toStringAsFixed(2)}", // Added space
                            "Latest Income",
                            Colors.green,
                          ),
                          _buildAmountColumn(
                            "- $currencySymbol ${recentExpense.toStringAsFixed(2)}", // Added space
                            "Latest Expense",
                            Colors.red,
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildAmountColumn(String amount, String label, Color color) {
    return Column(
      crossAxisAlignment: label.contains("Income")
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.end,
      children: [
        Text(
          amount,
          style: const TextStyle(color: Colors.white70, fontSize: 19),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: color, fontSize: 20)),
      ],
    );
  }
}
