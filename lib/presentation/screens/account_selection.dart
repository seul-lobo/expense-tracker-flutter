import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../routing/route_names.dart';
import '../cubits/user_cubit/user_state.dart';
import '../dialogs/add_new_account_dialog.dart';
import '../dialogs/cash_account_dialog.dart';
import '../dialogs/wallet_account_dialog.dart';
import '../dialogs/back_next_buttons.dart';
import '../cubits/user_cubit/user_cubit.dart';

class AccountSelection extends StatefulWidget {
  const AccountSelection({super.key});

  @override
  State<AccountSelection> createState() => _AccountSelectionState();
}

class _AccountSelectionState extends State<AccountSelection> {
  @override
  void initState() {
    super.initState();
    context.read<UserCubit>().loadUser();
  }

  void _openAddAccountDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (BuildContext context) => const AddNewAccountDialog(),
    );
  }

  void _openCashAccountDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (BuildContext context) => const CashAccountDialog(),
    );
  }

  void _openWalletAccountDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (BuildContext context) => const WalletAccountDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.08),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: height * 0.03),
              BlocBuilder<UserCubit, UserState>(
                builder: (context, state) {
                  String? userImagePath;
                  if (state is UserLoaded &&
                      state.user.profileImagePath.isNotEmpty) {
                    if (File(state.user.profileImagePath).existsSync()) {
                      userImagePath = state.user.profileImagePath;
                    }
                  }
                  return CircleAvatar(
                    radius: height * 0.035,
                    backgroundColor: theme.primaryColor,
                    backgroundImage: userImagePath != null
                        ? FileImage(File(userImagePath))
                        : null,
                    child: userImagePath == null
                        ? const Icon(Icons.person, color: Colors.white)
                        : null,
                  );
                },
              ),
              SizedBox(height: height * 0.03),
              Text(
                "Add Account",
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: height * 0.01),
              Text(
                "Recommended Accounts",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white54,
                ),
              ),
              SizedBox(height: height * 0.03),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: 1.2,
                  children: [
                    GestureDetector(
                      onTap: _openCashAccountDialog,
                      child: _accountCard("Cash", Icons.money, theme),
                    ),
                    GestureDetector(
                      onTap: _openAddAccountDialog,
                      child: _accountCard("Bank", Icons.account_balance, theme),
                    ),
                    GestureDetector(
                      onTap: _openWalletAccountDialog,
                      child: _accountCard(
                        "Wallet",
                        Icons.account_balance_wallet,
                        theme,
                      ),
                    ),
                    GestureDetector(
                      onTap: _openAddAccountDialog,
                      child: _accountCard(
                        "Add Account",
                        Icons.add,
                        theme,
                        dotted: true,
                      ),
                    ),
                  ],
                ),
              ),
              BackNextButtons(
                onBack: () => Navigator.pop(context),
                onNext: () =>
                    Navigator.pushNamed(context, RouteNames.selectCategory),
              ),
              SizedBox(height: height * 0.03),
            ],
          ),
        ),
      ),
    );
  }

  Widget _accountCard(
    String label,
    IconData icon,
    ThemeData theme, {
    bool dotted = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: dotted
            ? Border.all(
                color: Colors.white30,
                style: BorderStyle.solid,
                width: 1.2,
              )
            : null,
        color: Colors.white10,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 38, color: Colors.white),
            const SizedBox(height: 10),
            Text(label, style: theme.textTheme.bodyLarge),
          ],
        ),
      ),
    );
  }
}
