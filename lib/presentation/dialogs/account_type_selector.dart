import 'package:flutter/material.dart';
import 'accounts_dialog.dart';

void showAccountTypeSelector(BuildContext context) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text("Select Account Type"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.money),
            title: const Text("Cash"),
            onTap: () {
              Navigator.pop(context); // close dialog
              showAccountDialog(context, AccountDialogType.cash);
            },
          ),
          ListTile(
            leading: const Icon(Icons.account_balance_wallet),
            title: const Text("Wallet"),
            onTap: () {
              Navigator.pop(context);
              showAccountDialog(context, AccountDialogType.wallet);
            },
          ),
          ListTile(
            leading: const Icon(Icons.account_balance),
            title: const Text("Bank"),
            onTap: () {
              Navigator.pop(context);
              showAccountDialog(context, AccountDialogType.bank);
            },
          ),
        ],
      ),
    ),
  );
}
