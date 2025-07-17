import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/account_cubit/account_cubit.dart';
import '../cubits/currency_cubit/currency_cubit.dart';
import '../cubits/currency_cubit/currency_state.dart';
import '../cubits/transaction_cubit/transaction_cubit.dart';
import '../cubits/user_cubit/user_cubit.dart';
import '../cubits/user_cubit/user_state.dart';
import '../dialogs/empty_state.dart';
import '../dialogs/components/side_drawer.dart';
import '../dialogs/components/month_summary_card.dart';
import '../dialogs/components/total_balance_card.dart';
import '../dialogs/components/transaction_filters.dart';
import 'add_transaction_screen.dart';
import '../../domain/entities/currency_entity.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<UserCubit>().loadUser();
    context.read<TransactionCubit>().loadTransactions();
    context.read<AccountCubit>().loadAccounts();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      key: _scaffoldKey,
      drawer: SideDrawer(
        selectedItem: 'Home',
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: width * 0.06),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const TotalBalanceCard(),
                  SizedBox(height: height * 0.035),

                  Text(
                    'This Month',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: height * 0.02),
                  const MonthSummaryCard(),
                  SizedBox(height: height * 0.035),

                  Text(
                    'Transactions',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const TransactionFilters(),
                  const SizedBox(height: 16),

                  BlocBuilder<CurrencyCubit, CurrencyState>(
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
                          if (state is TransactionLoading) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (state is TransactionLoaded) {
                            final transactions = state.transactions;
                            if (transactions.isEmpty) {
                              return const EmptyState(
                                iconPath: 'assets/images/empty_state.svg',
                                title: 'No Transactions',
                                subtitle: 'Start by adding a transaction',
                              );
                            }

                            return ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: transactions.length,
                              separatorBuilder: (_, __) => const SizedBox(height: 12),
                              itemBuilder: (context, index) {
                                final tx = transactions[index];
                                return Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.black12,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            tx.name,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            tx.description,
                                            style: const TextStyle(
                                              color: Colors.white70,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        "${tx.type == 'Income' ? '+' : '-'} $currencySymbol ${tx.amount.toStringAsFixed(2)}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: tx.type == 'Income' ? Colors.green : Colors.red,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          } else {
                            return const Text(
                              'Something went wrong!',
                              style: TextStyle(color: Colors.redAccent),
                            );
                          }
                        },
                      );
                    },
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddTransactionScreen()),
          );
        },
        backgroundColor: theme.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}