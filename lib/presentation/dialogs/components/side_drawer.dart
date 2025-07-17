import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../routing/route_names.dart';

class SideDrawer extends StatelessWidget {
  final String selectedItem;
  final Function(String)? onItemSelected;

  const SideDrawer({
    super.key,
    this.onItemSelected,
    required this.selectedItem,
  });

  String _getRoute(String value) {
  switch (value) {
    case 'Home':
      return RouteNames.homeScreen;
    case 'Accounts':
      return RouteNames.accounts;
    case 'Debts':
      return RouteNames.debts;
    case 'Recurring':
      return RouteNames.recurring;
    case 'Overview':
      return RouteNames.overview;
    case 'Categories':
      return RouteNames.categories;
    case 'Budget':
      return RouteNames.budget;
    case 'Settings':
      return RouteNames.settings;
    default:
      return RouteNames.homeScreen;
  }
}


  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF1C1C1E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color(0xFFEFD56F).withOpacity(0.9),
                      Colors.black.withOpacity(0.7),
                    ],
                    stops: const [0.0, 0.7],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/images/logo_app.svg',
                      height: 32,
                      width: 32,
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      "EXPENSE TRACKER",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFDA4672),
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              ..._drawerItems.map((item) {
                final isSelected = item['title'] == selectedItem;
                return GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    if (!isSelected) {
                      onItemSelected?.call(_getRoute(item['title']!));
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFFEFD56F).withOpacity(0.2)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      item['title']!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: isSelected
                            ? const Color(0xFFEFD56F)
                            : Colors.white70,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              }).toList(),
              const Spacer(),
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 24,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color(0xFFEFD56F).withOpacity(0.9),
                      Colors.black.withOpacity(0.7),
                    ],
                    stops: const [0.0, 0.7],
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.yellow.withOpacity(0.5),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Text(
                  "Log Out",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFFDA4672),
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.yellowAccent,
                        offset: Offset(0, 0),
                        blurRadius: 3,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Map<String, String>> get _drawerItems => [
    {"title": "Home"},
    {"title": "Accounts"},
    {"title": "Debts"},
    {"title": "Overview"},
    {"title": "Categories"},
    {"title": "Budget"},
    {"title": "Recurring"},
    {"title": "Settings"},
  ];
}
