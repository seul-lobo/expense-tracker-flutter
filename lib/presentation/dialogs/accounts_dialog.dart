import 'package:flutter/material.dart';
import 'package:expense_tracker/presentation/dialogs/add_new_account_dialog.dart';
import 'wallet_account_dialog.dart';
import 'cash_account_dialog.dart';

enum AccountDialogType { bank, wallet, cash }

void showAccountDialog(BuildContext context, AccountDialogType type) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) {
      switch (type) {
        case AccountDialogType.bank:
          return const AddNewAccountDialog();
        case AccountDialogType.cash:
          return const CashAccountDialog();
        case AccountDialogType.wallet:
          return const WalletAccountDialog();
      }
    },
  );
}
