import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'core/theme/app_theme.dart';
import 'data/datasource/account_local_data_source.dart';
import 'data/datasource/category_local_data_source.dart';
import 'data/datasource/currency_local_data_source.dart';
import 'data/datasource/debt_local_data_source.dart';
import 'data/datasource/transaction_local_data_source.dart';
import 'data/datasource/user_local_data_source.dart';

import 'data/models/account_model.dart';
import 'data/models/category_model.dart';
import 'data/models/currency_model.dart';
import 'data/models/debt_model.dart';
import 'data/models/transaction_model.dart';
import 'data/models/user_model.dart';

import 'data/repositories/account_repository_impl.dart';
import 'data/repositories/category_repository_impl.dart';
import 'data/repositories/currency_repository_impl.dart';
import 'data/repositories/debt_repository_impl.dart';
import 'data/repositories/transaction_repository_impl.dart';
import 'data/repositories/user_repository_impl.dart';

import 'presentation/cubits/account_cubit/account_cubit.dart';
import 'presentation/cubits/category_cubit/category_cubit.dart';
import 'presentation/cubits/currency_cubit/currency_cubit.dart';
import 'presentation/cubits/debt_cubit/debt_cubit.dart';
import 'presentation/cubits/transaction_cubit/transaction_cubit.dart';
import 'presentation/cubits/user_cubit/user_cubit.dart';

import 'routing/route_names.dart';
import 'routing/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final appDir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDir.path);

  // Register all adapters
  Hive.registerAdapter(TransactionModelAdapter());
  Hive.registerAdapter(UserModelAdapter());
  Hive.registerAdapter(AccountModelAdapter());
  Hive.registerAdapter(CategoryModelAdapter());
  Hive.registerAdapter(CurrencyModelAdapter());
  Hive.registerAdapter(DebtModelAdapter());

  // Delete and reopen boxes to handle schema change
  await Hive.deleteBoxFromDisk('debts');
  print('Deleted debts box from disk to handle schema change');
  await Hive.deleteBoxFromDisk('transactions');
  print('Deleted transactions box from disk to handle schema change');
  await Hive.deleteBoxFromDisk('userBox');
  print('Deleted users box from disk to handle schema change');
  await Hive.deleteBoxFromDisk('accountBox');
  print('Deleted account box from disk to handle schema change');
  await Hive.deleteBoxFromDisk('categoryBox');
  print('Deleted category box from disk to handle schema change');
  await Hive.deleteBoxFromDisk('currencyBox');
  print('Deleted currency box from disk to handle schema change');

  // Open boxes
  final transactionBox = await Hive.openBox<TransactionModel>('transactions');
  final userBox = await Hive.openBox<UserModel>('userBox');
  final accountBox = await Hive.openBox<AccountModel>('accountBox');
  final categoryBox = await Hive.openBox<CategoryModel>('categoryBox');
  final currencyBox = await Hive.openBox<CurrencyModel>('currencyBox');
  final debtBox = await Hive.openBox<DebtModel>('debts');

  // Data Sources
  final transactionDS = TransactionLocalDataSourceImpl(transactionBox);
  final userDS = UserLocalDataSourceImpl(userBox);
  final accountDS = AccountLocalDataSourceImpl(accountBox);
  final categoryDS = CategoryLocalDataSourceImpl(categoryBox);
  final currencyDS = CurrencyLocalDataSourceImpl(currencyBox);
  final debtDS = DebtLocalDataSourceImpl(debtBox);

  // Repositories
  final transactionRepo = TransactionRepositoryImpl(transactionDS);
  final userRepo = UserRepositoryImpl(userDS);
  final accountRepo = AccountRepositoryImpl(accountDS);
  final categoryRepo = CategoryRepositoryImpl(categoryDS);
  final currencyRepo = CurrencyRepositoryImpl(currencyDS);
  final debtRepo = DebtRepositoryImpl(debtDS);

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => TransactionCubit(transactionRepo)..loadTransactions(),
        ),
        BlocProvider(create: (_) => UserCubit(userRepo)..loadUser()),
        BlocProvider(create: (_) => AccountCubit(accountRepo)..loadAccounts()),
        BlocProvider(
          create: (_) => CategoryCubit(categoryRepo)..loadCategories(),
        ),
        BlocProvider(
          create: (_) => CurrencyCubit(currencyRepo)..loadCurrencies(),
        ),
        BlocProvider(
          create: (context) => DebtCubit(
            debtRepo: debtRepo,
            accountCubit: context.read<AccountCubit>(),
            transactionCubit: context.read<TransactionCubit>(),
          )..loadDebts(),
        ),
      ],
      child: const ExpenseTrackerApp(),
    ),
  );
}

class ExpenseTrackerApp extends StatelessWidget {
  const ExpenseTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      initialRoute: RouteNames.splash,
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}
