import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/user_entity.dart';
import '../cubits/user_cubit/user_cubit.dart';
import '../cubits/user_cubit/user_state.dart';
import '../dialogs/back_next_buttons.dart';

class CategorySelection extends StatefulWidget {
  const CategorySelection({super.key});

  @override
  State<CategorySelection> createState() => _CategorySelectionState();
}

class _CategorySelectionState extends State<CategorySelection> {
  final List<Map<String, dynamic>> categories = [
    {"name": "Groceries", "icon": Icons.shopping_cart},
    {"name": "Bills", "icon": Icons.receipt_long},
    {"name": "Travel", "icon": Icons.flight_takeoff},
    {"name": "Food", "icon": Icons.fastfood},
    {"name": "Salary", "icon": Icons.attach_money},
    {"name": "Shopping", "icon": Icons.shopping_bag},
  ];

  final List<String> selectedCategories = [];

  String? userImagePath;

  @override
  void initState() {
    super.initState();
    context.read<UserCubit>().loadUser();
  }

  void _toggleSelection(String name) {
    setState(() {
      if (selectedCategories.contains(name)) {
        selectedCategories.remove(name);
      } else {
        selectedCategories.add(name);
      }
    });
  }

 void _handleNext() async {
  final selected = selectedCategories.toList(); // from UI

  final cubit = context.read<UserCubit>();
  final state = cubit.state;

  if (state is UserLoaded) {
    final updatedUser = UserEntity(
      name: state.user.name,
      profileImagePath: state.user.profileImagePath,
      selectedCategories: selected, // ✅ SAVE SELECTED
    );

    await cubit.saveUser(updatedUser);
  }

  Navigator.pushNamed(context, '/selectCurrency');
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
            // Top section with padding
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.06),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: height * 0.02),
                    // User avatar and title
                    Row(
                      children: [
                        BlocBuilder<UserCubit, UserState>(
                          builder: (context, state) {
                            String? imagePath;
                            if (state is UserLoaded &&
                                state.user.profileImagePath.isNotEmpty &&
                                File(
                                  state.user.profileImagePath,
                                ).existsSync()) {
                              imagePath = state.user.profileImagePath;
                            }

                            return CircleAvatar(
                              radius: 24,
                              backgroundImage: imagePath != null
                                  ? FileImage(File(imagePath))
                                  : null,
                              child: imagePath == null
                                  ? const Icon(
                                      Icons.person,
                                      color: Colors.white,
                                    )
                                  : null,
                            );
                          },
                        ),

                        SizedBox(width: width * 0.03),
                        Text(
                          "Add Category",
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: height * 0.03),
                    Text(
                      "Recommended Categories",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: height * 0.02),
                    // Category grid
                    Expanded(
                      child: GridView.builder(
                        padding: const EdgeInsets.only(bottom: 20),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: height * 0.02,
                          crossAxisSpacing: width * 0.04,
                          childAspectRatio: 1,
                        ),
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          final item = categories[index];
                          final isSelected = selectedCategories.contains(
                            item['name'],
                          );

                          return GestureDetector(
                            onTap: () => _toggleSelection(item['name']),
                            child: Container(
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? theme.primaryColor
                                    : Colors.white10,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected
                                      ? theme.primaryColor
                                      : Colors.white12,
                                  width: 2,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    item['icon'],
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    item['name'],
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Consistent navigation buttons
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
