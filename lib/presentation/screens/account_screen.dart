import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/account_cubit/account_cubit.dart';
import '../cubits/user_cubit/user_cubit.dart';
import '../cubits/user_cubit/user_state.dart';
import '../dialogs/add_new_account_dialog.dart';
import '../dialogs/components/side_drawer.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    context.read<UserCubit>().loadUser();
    context.read<AccountCubit>().loadAccounts();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      key: _scaffoldKey,
      drawer: SideDrawer(
        selectedItem: 'Accounts',
        onItemSelected: (routeName) {
          Navigator.pushReplacementNamed(context, routeName);
        },
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        title: BlocBuilder<UserCubit, UserState>(
          builder: (context, state) {
            String name = "User";
            String? userImage;

            if (state is UserLoaded) {
              name = state.user.name;
              if (state.user.profileImagePath.isNotEmpty &&
                  File(state.user.profileImagePath).existsSync()) {
                userImage = state.user.profileImagePath;
              }
            }

            return Text(
              'Hello, $name',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            );
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: BlocBuilder<UserCubit, UserState>(
              builder: (context, state) {
                String? userImage;

                if (state is UserLoaded &&
                    state.user.profileImagePath.isNotEmpty &&
                    File(state.user.profileImagePath).existsSync()) {
                  userImage = state.user.profileImagePath;
                }

                return CircleAvatar(
                  backgroundColor: theme.primaryColor,
                  backgroundImage: userImage != null
                      ? FileImage(File(userImage))
                      : null,
                  child: userImage == null
                      ? const Icon(Icons.person, color: Colors.white)
                      : null,
                );
              },
            ),
          ),
        ],
      ),
      body: BlocBuilder<AccountCubit, AccountState>(
        builder: (context, state) {
          if (state is AccountLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AccountLoaded) {
            final accounts = state.accounts;

            if (accounts.isEmpty) {
              return const Center(
                child: Text(
                  'No accounts found',
                  style: TextStyle(color: Colors.white70),
                ),
              );
            }

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: width * 0.06),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(accounts.length, (index) {
                  final account = accounts[index];
                  return _accountCard(
                    holderName: account.name,
                    bankName: "ID: ${account.id}",
                    amount: account.balance,
                    income: account
                        .balance, // You can replace with actual income if needed
                    expense: 0, // Replace with actual expense if needed
                    onDelete: () {
                      context.read<AccountCubit>().deleteAccount(index);
                    },
                  );
                }),
              ),
            );
          } else {
            return const Center(
              child: Text(
                'Failed to load accounts',
                style: TextStyle(color: Colors.red),
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.black,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
            ),
            builder: (context) => const AddNewAccountDialog(),
          );
        },
        backgroundColor: theme.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _accountCard({
    required String holderName,
    required String bankName,
    required double amount,
    required double income,
    required double expense,
    required VoidCallback onDelete,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
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
          /// Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$holderName | $bankName',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: onDelete,
              ),
            ],
          ),

          const SizedBox(height: 16),

          /// Total Amount
          Text(
            '\$${amount.toStringAsFixed(2)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Total',
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),

          const SizedBox(height: 20),

          /// Income & Expense
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '+ \$${income.toStringAsFixed(2)}',
                    style: const TextStyle(color: Colors.white70, fontSize: 19),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Income',
                    style: TextStyle(color: Colors.green, fontSize: 24),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '- \$${expense.toStringAsFixed(2)}',
                    style: const TextStyle(color: Colors.white70, fontSize: 19),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Expense',
                    style: TextStyle(color: Colors.red, fontSize: 24),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
