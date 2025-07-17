import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../../domain/entities/debt_entity.dart';
import '../../../domain/entities/transaction_entity.dart';
import '../../domain/entities/currency_entity.dart';
import '../cubits/account_cubit/account_cubit.dart';
import '../cubits/currency_cubit/currency_cubit.dart';
import '../cubits/currency_cubit/currency_state.dart';
import '../cubits/debt_cubit/debt_cubit.dart';
import '../cubits/transaction_cubit/transaction_cubit.dart';

class PayCollectDialog extends StatelessWidget {
  final DebtEntity debt;
  final AccountCubit accountCubit;
  final TransactionCubit transactionCubit;
  final DebtCubit debtCubit;

  const PayCollectDialog({
    super.key,
    required this.debt,
    required this.accountCubit,
    required this.transactionCubit,
    required this.debtCubit,
  });

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

        return AlertDialog(
          backgroundColor: Colors.black,
          title: Text(
            debt.isDebt ? "Confirm Payment" : "Confirm Collection",
            style: const TextStyle(color: Colors.white),
          ),
          content: Text(
            debt.isDebt
                ? "Do you want to pay $currencySymbol ${debt.amount.toStringAsFixed(2)} to ${debt.name}?"
                : "Do you want to collect $currencySymbol ${debt.amount.toStringAsFixed(2)} from ${debt.name}?",
            style: const TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "Cancel",
                style: TextStyle(color: Colors.amber),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  // Update account balance
                  await accountCubit.updateBalance(
                    debt.accountId,
                    debt.amount,
                    !debt.isDebt, // debt = expense (subtract), credit = income (add)
                  );

                  // Create transaction
                  final transaction = TransactionEntity(
                    id: const Uuid().v4(),
                    name: debt.isDebt ? "Debt Paid" : "Credit Collected",
                    amount: debt.amount,
                    description: debt.description,
                    type: debt.isDebt ? "Expense" : "Income",
                    category: "Debt",
                    dateTime: DateTime.now(),
                    accountId: debt.accountId,
                  );
                  await transactionCubit.addTransaction(transaction);

                  // Remove from debts
                  await debtCubit.deleteDebt(debt);

                  // Close dialog
                  Navigator.pop(context);
                } catch (e) {
                  // Show error dialog if something goes wrong
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      backgroundColor: Colors.black,
                      title: const Text(
                        "Error",
                        style: TextStyle(color: Colors.white),
                      ),
                      content: Text(
                        "Failed to process ${debt.isDebt ? 'payment' : 'collection'}: $e",
                        style: const TextStyle(color: Colors.white70),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            "OK",
                            style: TextStyle(color: Colors.amber),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Confirm",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}