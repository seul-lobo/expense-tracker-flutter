import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/currency_cubit/currency_cubit.dart';
import '../cubits/currency_cubit/currency_state.dart';
import '../cubits/user_cubit/user_cubit.dart';
import '../cubits/user_cubit/user_state.dart';
import '../dialogs/back_next_buttons.dart';
import '../../routing/route_names.dart';

class SelectCurrencyScreen extends StatefulWidget {
  const SelectCurrencyScreen({super.key});

  @override
  State<SelectCurrencyScreen> createState() => _SelectCurrencyScreenState();
}

class _SelectCurrencyScreenState extends State<SelectCurrencyScreen> {
  String? userImagePath;
  int? selectedIndex;
  bool _hasInitializedCurrencies = false;

  @override
  void initState() {
    super.initState();
    print('SelectCurrencyScreen: Initializing');
    context.read<UserCubit>().loadUser();
    context.read<CurrencyCubit>().loadCurrencies();
  }

  void _handleNext() async {
    if (selectedIndex == null) {
      print('No currency selected');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a currency')));
      return;
    }

    final cubit = context.read<CurrencyCubit>();
    final state = cubit.state;

    if (state is CurrencyLoaded) {
      print('Saving selected currency at index: $selectedIndex');
      final updatedList = state.currencies.asMap().entries.map((entry) {
        final i = entry.key;
        final c = entry.value;
        return c.copyWith(isSelected: i == selectedIndex);
      }).toList();

      await cubit.saveCurrencies(updatedList);
      Navigator.pushNamed(context, RouteNames.homeScreen);
    } else {
      print('Cannot save currencies: Invalid state $state');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.08),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: height * 0.02),
                    BlocBuilder<UserCubit, UserState>(
                      builder: (context, state) {
                        print('UserCubit state: $state');
                        if (state is UserLoaded &&
                            state.user.profileImagePath.isNotEmpty &&
                            File(state.user.profileImagePath).existsSync()) {
                          userImagePath = state.user.profileImagePath;
                        } else {
                          userImagePath = null;
                        }

                        return Row(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundImage: userImagePath != null
                                  ? FileImage(File(userImagePath!))
                                  : null,
                              child: userImagePath == null
                                  ? const Icon(
                                      Icons.person,
                                      color: Colors.white,
                                    )
                                  : null,
                            ),
                            SizedBox(width: width * 0.03),
                            Text(
                              "Select Currency",
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    SizedBox(height: height * 0.03),
                    Text(
                      "Choose your default currency",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: height * 0.03),
                    Expanded(
                      child: BlocBuilder<CurrencyCubit, CurrencyState>(
                        builder: (context, state) {
                          print('CurrencyCubit state: $state');
                          if (state is CurrencyLoaded) {
                            final currencies = state.currencies;
                            print('Currencies loaded: ${currencies.length}');
                            if (currencies.isEmpty &&
                                !_hasInitializedCurrencies) {
                              print(
                                'No currencies, triggering initDefaultCurrencies',
                              );
                              _hasInitializedCurrencies = true;
                              context
                                  .read<CurrencyCubit>()
                                  .initDefaultCurrencies();
                              return const Center(
                                child: Text(
                                  "Initializing currencies...",
                                  style: TextStyle(color: Colors.white),
                                ),
                              );
                            }

                            return GridView.builder(
                              itemCount: currencies.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    mainAxisSpacing: 16,
                                    crossAxisSpacing: 16,
                                    childAspectRatio: 1.2,
                                  ),
                              itemBuilder: (context, index) {
                                final currency = currencies[index];
                                final isSelected =
                                    selectedIndex == index ||
                                    currency.isSelected;

                                return GestureDetector(
                                  onTap: () {
                                    print(
                                      'Selected currency: ${currency.name}',
                                    );
                                    setState(() => selectedIndex = index);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? theme.primaryColor
                                          : Colors.white10,
                                      border: Border.all(
                                        color: isSelected
                                            ? theme.primaryColor
                                            : Colors.white12,
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            currency.symbol,
                                            style: theme.textTheme.bodyLarge
                                                ?.copyWith(
                                                  fontSize: 26,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            currency.name,
                                            style: theme.textTheme.bodyMedium
                                                ?.copyWith(
                                                  color: Colors.white70,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          } else if (state is CurrencyLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (state is CurrencyError) {
                            return Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "Error: ${state.message}",
                                    style: const TextStyle(color: Colors.red),
                                  ),
                                  const SizedBox(height: 16),
                                  ElevatedButton(
                                    onPressed: () {
                                      context
                                          .read<CurrencyCubit>()
                                          .loadCurrencies();
                                    },
                                    child: const Text('Retry'),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            if (!_hasInitializedCurrencies) {
                              print(
                                'No currencies loaded, triggering initDefaultCurrencies',
                              );
                              _hasInitializedCurrencies = true;
                              context
                                  .read<CurrencyCubit>()
                                  .initDefaultCurrencies();
                            }
                            return const Center(
                              child: Text(
                                "Initializing currencies...",
                                style: TextStyle(color: Colors.white),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.08,
                vertical: height * 0.03,
              ),
              child: BackNextButtons(
                onBack: () => Navigator.pop(context),
                onNext: _handleNext,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
