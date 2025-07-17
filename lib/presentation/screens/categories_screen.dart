import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/user_cubit/user_cubit.dart';
import '../cubits/user_cubit/user_state.dart';
import '../dialogs/components/side_drawer.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String username = "User";
  String? userImagePath;

  List<Map<String, dynamic>> categories = [
    {"name": "Grocery", "icon": Icons.shopping_cart, "color": Colors.pink},
    {"name": "Education", "icon": Icons.school, "color": Colors.lightBlue},
  ];

  @override
  void initState() {
    super.initState();
    context.read<UserCubit>().loadUser();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
      drawer: SideDrawer(
        selectedItem: 'Categories',
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
        child: ListView.builder(
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: category['color'],
                    child: Icon(category['icon'], color: Colors.white),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Text(
                      category['name'],
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/addCategory'),
        backgroundColor: theme.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
