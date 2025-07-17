import 'package:flutter/material.dart';
import '../dialogs/components/side_drawer.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Map<String, dynamic>> budgets = [
    {"category": "Groceries", "limit": 5000, "spent": 2700},
    {"category": "Entertainment", "limit": 3000, "spent": 1200},
    {"category": "Bills", "limit": 4000, "spent": 3900},
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      key: _scaffoldKey,
      drawer: SideDrawer(
        selectedItem: "Budget",
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
        title: const Text("Budgets", style: TextStyle(color: Colors.white)),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(color: Colors.white12, height: 1),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: budgets.isEmpty
            ? const Center(
                child: Text(
                  "No budgets set yet.",
                  style: TextStyle(color: Colors.white60),
                ),
              )
            : ListView.separated(
                itemCount: budgets.length,
                separatorBuilder: (_, __) => const SizedBox(height: 20),
                itemBuilder: (context, index) {
                  final budget = budgets[index];
                  final progress = (budget["spent"] / budget["limit"]).clamp(
                    0.0,
                    1.0,
                  );
                  final remaining = budget["limit"] - budget["spent"];
                  return Container(
                    padding: const EdgeInsets.all(20),
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
                          color: Colors.white.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Category and Amounts
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              budget["category"],
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              "\$${budget['spent']} / \$${budget['limit']}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        /// Progress Bar
                        LinearProgressIndicator(
                          value: progress,
                          backgroundColor: Colors.white24,
                          color: progress > 0.9
                              ? Colors.red
                              : progress > 0.7
                              ? Colors.orange
                              : Colors.greenAccent,
                          minHeight: 8,
                          borderRadius: BorderRadius.circular(20),
                        ),

                        const SizedBox(height: 8),
                        Text(
                          "${remaining < 0 ? 'Over' : 'Remaining'}: \$${remaining.abs()}",
                          style: TextStyle(
                            color: remaining < 0
                                ? Colors.redAccent
                                : Colors.white70,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Add add-budget screen navigation
        },
        backgroundColor: theme.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
