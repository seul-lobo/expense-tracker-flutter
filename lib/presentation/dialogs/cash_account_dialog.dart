import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/account_entity.dart';
import '../cubits/account_cubit/account_cubit.dart';

class CashAccountDialog extends StatefulWidget {
  const CashAccountDialog({super.key});

  @override
  State<CashAccountDialog> createState() => _CashAccountDialogState();
}

class _CashAccountDialogState extends State<CashAccountDialog> {
  final TextEditingController _amountController = TextEditingController();

  void _handleAdd() {
  final amount = double.tryParse(_amountController.text.trim());

  if (amount == null || amount < 0) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Please enter a valid amount")),
    );
    return;
  }

  // ✅ Assign unique ID (e.g., timestamp or Hive box length if available)
  final cashAccount = AccountEntity(
    id: DateTime.now().millisecondsSinceEpoch, // ← add this line
    name: "Cash",
    balance: amount,
    colorHex: Colors.amber.value,
    isSelected: false,
    isDefault: true,
    isExcluded: false,
  );

  context.read<AccountCubit>().addAccount(cashAccount);
  Navigator.pop(context);
}


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 30,
        top: 20,
        left: 20,
        right: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Enter Cash Amount", style: theme.textTheme.headlineSmall),
          const SizedBox(height: 20),
          TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: "Amount",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _handleAdd,
            child: const Text("Add Cash Account"),
          ),
        ],
      ),
    );
  }
}
