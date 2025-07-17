import 'package:expense_tracker/domain/entities/debt_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expense_tracker/presentation/cubits/debt_cubit/debt_cubit.dart';
import 'package:expense_tracker/routing/route_names.dart';
import '../cubits/account_cubit/account_cubit.dart';
import '../cubits/currency_cubit/currency_cubit.dart';
import '../cubits/currency_cubit/currency_state.dart';
import '../cubits/transaction_cubit/transaction_cubit.dart';
import '../dialogs/empty_state.dart';
import '../dialogs/components/side_drawer.dart';
import '../dialogs/pay_collect_dialog.dart';
import '../../domain/entities/currency_entity.dart';

class DebtScreen extends StatefulWidget {
  const DebtScreen({super.key});

  @override
  State<DebtScreen> createState() => _DebtScreenState();
}

class _DebtScreenState extends State<DebtScreen> {
  String selectedType = ''; // '', 'Debt', 'Credit'
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    context.read<DebtCubit>().loadDebts();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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

        return Scaffold(
          key: _scaffoldKey,
          drawer: SideDrawer(
            selectedItem: 'Debts',
            onItemSelected: (routeName) {
              Navigator.pushReplacementNamed(context, routeName);
            },
          ),
          appBar: AppBar(
            title: const Text('Debts'),
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () => _scaffoldKey.currentState?.openDrawer(),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.search, color: Colors.white),
                onPressed: () {},
              ),
            ],
            bottom: const PreferredSize(
              preferredSize: Size.fromHeight(1),
              child: Divider(color: Colors.white12, height: 1),
            ),
          ),
          backgroundColor: theme.scaffoldBackgroundColor,
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                /// Filter Chips
                Wrap(
                  spacing: 10,
                  children: ['Debt', 'Credit'].map((type) {
                    final isSelected = selectedType == type;
                    return ChoiceChip(
                      label: Text(type),
                      selected: isSelected,
                      onSelected: (_) {
                        setState(() {
                          selectedType = isSelected ? '' : type;
                        });
                      },
                      selectedColor: Colors.black,
                      backgroundColor: const Color.fromARGB(
                        255,
                        204,
                        195,
                        111,
                      ).withOpacity(0.8),
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),

                /// Debt List
                Expanded(
                  child: BlocBuilder<DebtCubit, DebtState>(
                    builder: (context, state) {
                      if (state is DebtLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is DebtLoaded) {
                        final debts = selectedType.isEmpty
                            ? state.debts
                            : state.debts
                                .where(
                                  (d) =>
                                      selectedType ==
                                      (d.isDebt ? 'Debt' : 'Credit'),
                                )
                                .toList();

                        if (debts.isEmpty) {
                          return const EmptyState(
                            iconPath: 'assets/images/empty_state.svg',
                            title: 'No Debts or Credits',
                            subtitle: 'Add some debts or credits to manage here',
                          );
                        }

                        return ListView.separated(
                          itemCount: debts.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 16),
                          itemBuilder: (context, index) {
                            final debt = debts[index];
                            return _debtCard(
                              debt: debt,
                              currencySymbol: currencySymbol,
                            );
                          },
                        );
                      } else if (state is DebtError) {
                        return Center(child: Text(state.message));
                      }

                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, RouteNames.addDebt);
            },
            backgroundColor: theme.primaryColor,
            child: const Icon(Icons.add, color: Colors.white),
          ),
        );
      },
    );
  }

  Widget _debtCard({required DebtEntity debt, required String currencySymbol}) {
    final daysLeft = debt.dueDate.difference(DateTime.now()).inDays;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: [
            const Color(0xFFEFD56F).withOpacity(0.9),
            Colors.black.withOpacity(0.7),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Title & Amount
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                debt.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                  color: Colors.black,
                ),
              ),
              Text(
                '$currencySymbol ${debt.amount.toStringAsFixed(2)}', // Dynamic symbol with space
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          /// Description
          Text(
            debt.description,
            style: const TextStyle(fontSize: 15, color: Colors.white70),
          ),
          const SizedBox(height: 12),

          /// Due Date & Action
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "$daysLeft days left",
                style: const TextStyle(
                  color: Colors.white60,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => PayCollectDialog(
                      debt: debt,
                      accountCubit: context.read<AccountCubit>(),
                      transactionCubit: context.read<TransactionCubit>(),
                      debtCubit: context.read<DebtCubit>(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                icon: const Icon(Icons.credit_card, size: 20),
                label: Text(debt.isDebt ? "Pay Debt" : "Collect Credit"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}