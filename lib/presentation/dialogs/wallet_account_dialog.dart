import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/account_entity.dart';
import '../cubits/account_cubit/account_cubit.dart';

class WalletAccountDialog extends StatefulWidget {
  const WalletAccountDialog({super.key});

  @override
  State<WalletAccountDialog> createState() => _WalletAccountDialogState();
}

class _WalletAccountDialogState extends State<WalletAccountDialog> {
  String? selectedWallet;
  final _amountController = TextEditingController();

  final walletOptions = ['SadaPay', 'NayaPay', 'JazzCash', 'Easypaisa'];

  void _handleAdd() {
    final amount = double.tryParse(_amountController.text.trim()) ?? 0;

    if (selectedWallet == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please select a wallet")));
      return;
    }

    final walletAccount = AccountEntity(
      id: DateTime.now().millisecondsSinceEpoch, // ✅ Add unique ID
      name: selectedWallet!,
      balance: amount,
      colorHex: 0xFF90CAF9, // Light blue
      isSelected: false,
      isDefault: false,
      isExcluded: false,
    );

    context.read<AccountCubit>().addAccount(walletAccount);
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
          Text("Select Wallet Type", style: theme.textTheme.headlineSmall),
          const SizedBox(height: 20),
          DropdownButtonFormField<String>(
            items: walletOptions.map((e) {
              return DropdownMenuItem(value: e, child: Text(e));
            }).toList(),
            value: selectedWallet,
            onChanged: (val) => setState(() => selectedWallet = val),
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Choose Wallet",
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: "Amount (optional)",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _handleAdd,
            child: const Text("Add Wallet Account"),
          ),
        ],
      ),
    );
  }
}
