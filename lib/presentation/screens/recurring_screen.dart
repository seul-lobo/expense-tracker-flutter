import 'package:flutter/material.dart';
import 'package:expense_tracker/presentation/dialogs/empty_state.dart';
import 'package:expense_tracker/presentation/dialogs/components/side_drawer.dart';
import 'package:expense_tracker/presentation/dialogs/components/recurring_card.dart';

class RecurringScreen extends StatefulWidget {
  const RecurringScreen({super.key});

  @override
  State<RecurringScreen> createState() => _RecurringScreenState();
}

class _RecurringScreenState extends State<RecurringScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Map<String, dynamic>> recurringEvents = [
    {"title": "Recurring 1", "period": "Daily", "time": "27 Wed - 12:57 PM"},
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      key: _scaffoldKey,
      drawer: SideDrawer(
        selectedItem: 'Recurring',
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
        title: const Text("Recurring", style: TextStyle(color: Colors.white)),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.search, color: Colors.white),
          ),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(color: Colors.white12, height: 1),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: recurringEvents.isEmpty
            ? const EmptyState(
                iconPath: 'assets/images/empty_state.svg',
                title: 'No Recurring Events',
                subtitle: 'Add recurring events to find them here',
              )
            : ListView.separated(
                itemCount: recurringEvents.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final item = recurringEvents[index];
                  return RecurringCard(
                    title: item['title'],
                    periodTime: "${item['period']} - ${item['time']}",
                    onDelete: () {
                      setState(() {
                        recurringEvents.removeAt(index);
                      });
                    },
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/addRecurring');
        },
        backgroundColor: theme.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
