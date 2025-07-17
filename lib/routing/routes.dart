import 'package:flutter/material.dart';
import '../presentation/screens/add_category_screen.dart';
import '../presentation/screens/add_recurring_screen.dart';
import '../presentation/screens/budget_screen.dart';
import '../presentation/screens/categories_screen.dart';
import '../presentation/screens/overview_screen.dart';
import '../presentation/screens/splash_screen.dart';
import '../presentation/screens/register_screen.dart';
import '../presentation/screens/home_screen.dart';
import '../presentation/screens/set_image.dart';
import '../presentation/screens/category_selection.dart';
import '../presentation/screens/currency_selection.dart';
import '../presentation/screens/account_screen.dart';
import '../presentation/screens/add_account_screen.dart';
import '../presentation/screens/account_selection.dart';
import '../presentation/screens/debt_screen.dart';
import '../presentation/screens/add_debt_screen.dart';
import '../presentation/screens/recurring_screen.dart'; // ✅ Add this

import 'route_names.dart';

class AppRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case RouteNames.register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case RouteNames.setupImage:
        return MaterialPageRoute(builder: (_) => const SetImageScreen());
      case RouteNames.accountSelection:
        return MaterialPageRoute(builder: (_) => const AccountSelection());
      case RouteNames.selectCategory:
        return MaterialPageRoute(builder: (_) => const CategorySelection());
      case RouteNames.selectCurrency:
        return MaterialPageRoute(builder: (_) => const SelectCurrencyScreen());
      case RouteNames.homeScreen:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case RouteNames.accounts:
        return MaterialPageRoute(builder: (_) => const AccountScreen());
      case RouteNames.addAccount:
        return MaterialPageRoute(builder: (_) => const AddAccountScreen());
      case RouteNames.debts:
        return MaterialPageRoute(builder: (_) => const DebtScreen());
      case RouteNames.addDebt:
        return MaterialPageRoute(builder: (_) => const AddDebtScreen());
      case RouteNames.recurring:
        return MaterialPageRoute(builder: (_) => const RecurringScreen());
      case RouteNames.addRecurring:
        return MaterialPageRoute(builder: (_) => const AddRecurringScreen());
      case RouteNames.budget:
        return MaterialPageRoute(builder: (_) => const BudgetScreen());
      case RouteNames.overview:
        return MaterialPageRoute(builder: (_) => const OverviewScreen());
      case RouteNames.categories:
        return MaterialPageRoute(builder: (_) => const CategoriesScreen());

      case RouteNames.addCategory:
        return MaterialPageRoute(builder: (_) => const AddCategoryScreen());

      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text("404 - Page Not Found"))),
        );
    }
  }
}
