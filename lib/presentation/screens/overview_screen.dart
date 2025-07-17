import 'dart:io';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../cubits/user_cubit/user_cubit.dart';
import '../cubits/user_cubit/user_state.dart';
import '../dialogs/components/side_drawer.dart';

class OverviewScreen extends StatefulWidget {
  const OverviewScreen({super.key});

  @override
  State<OverviewScreen> createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<String> timeFilters = ['Daily', 'Weekly', 'Monthly', 'Yearly'];
  final List<String> types = ['Income', 'Expense', 'Both'];

  String selectedTime = 'Daily';
  String selectedType = 'Expense';

  List<Map<String, dynamic>> dummyCategoryData = [
    {
      "name": "Grocery",
      "icon": Icons.shopping_cart,
      "spent": 5000.0,
      "budget": 5000.0,
    },
    {"name": "Rent", "icon": Icons.house, "spent": 10000.0, "budget": 10000.0},
  ];

  double get income => 15000;
  double get expense => dummyCategoryData.fold(
    0.0,
    (prev, item) => prev + (item["spent"] as double),
  );

  @override
  void initState() {
    super.initState();
    context.read<UserCubit>().loadUser();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = MediaQuery.of(context).size.width;
    final Color highlightColor = const Color.fromARGB(255, 204, 195, 111);

    return Scaffold(
      key: _scaffoldKey,
      drawer: SideDrawer(
        selectedItem: 'Overview',
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
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.06),
        child: Column(
          children: [
            const SizedBox(height: 16),

            /// Time filters
            SizedBox(
              height: 36,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: timeFilters.map((filter) {
                  final isSelected = filter == selectedTime;
                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: ChoiceChip(
                      label: Text(filter),
                      selected: isSelected,
                      onSelected: (_) => setState(() => selectedTime = filter),
                      selectedColor: highlightColor,
                      backgroundColor: Colors.black54,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.black : Colors.white70,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 16),

            /// Bar chart box
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: highlightColor),
                borderRadius: BorderRadius.circular(14),
              ),
              height: 160,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  barTouchData: BarTouchData(enabled: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '\$${value.toInt()}',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 10,
                            ),
                          );
                        },
                        interval: 4000,
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value == 0 ? "27 Mar" : "28 Mar",
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 10,
                            ),
                          );
                        },
                      ),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: [
                    BarChartGroupData(
                      x: 0,
                      barRods: [
                        BarChartRodData(
                          toY: 4000,
                          width: 8,
                          color: highlightColor,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ],
                    ),
                    BarChartGroupData(
                      x: 1,
                      barRods: [
                        BarChartRodData(
                          toY: 4000,
                          width: 8,
                          color: highlightColor,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// Type filters
            Row(
              children: types.map((type) {
                final isSelected = selectedType == type;
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: ChoiceChip(
                    label: Text(type),
                    selected: isSelected,
                    onSelected: (_) => setState(() => selectedType = type),
                    selectedColor: highlightColor,
                    backgroundColor: Colors.black45,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.black : Colors.white,
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 24),

            /// Pie Chart
            SizedBox(
              height: 160,
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      color: Colors.greenAccent.shade400,
                      value: income,
                      title: 'Income',
                      radius: 40,
                      titleStyle: const TextStyle(color: Colors.black),
                    ),
                    PieChartSectionData(
                      color: Colors.red.shade400,
                      value: expense,
                      title: 'Expense',
                      radius: 40,
                      titleStyle: const TextStyle(color: Colors.black),
                    ),
                  ],
                  sectionsSpace: 2,
                  centerSpaceRadius: 30,
                ),
              ),
            ),

            const SizedBox(height: 16),

            /// Category List
            Expanded(
              child: ListView.builder(
                itemCount: dummyCategoryData.length,
                itemBuilder: (context, index) {
                  final item = dummyCategoryData[index];
                  final percent = (item["spent"] / item["budget"]).clamp(
                    0.0,
                    1.0,
                  );
                  return Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.black87,
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: highlightColor.withOpacity(0.3),
                          child: Icon(item["icon"], color: Colors.white),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item["name"],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 6),
                              LinearProgressIndicator(
                                value: percent,
                                minHeight: 6,
                                color: highlightColor,
                                backgroundColor: Colors.white24,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '-\$${item["spent"].toStringAsFixed(2)}',
                                style: const TextStyle(
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
