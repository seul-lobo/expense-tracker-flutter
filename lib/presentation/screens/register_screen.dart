import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import '../../routing/route_names.dart';
import '../dialogs/back_next_buttons.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/user_entity.dart';
import '../cubits/user_cubit/user_cubit.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  String? _nameError;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_validateName);
  }

  void _validateName() {
    final name = _nameController.text.trim();
    setState(() {
      if (name.isEmpty) {
        _nameError = 'Name is required';
      } else if (name.length < 2) {
        _nameError = 'Name must be at least 2 characters';
      } else if (name.length > 50) {
        _nameError = 'Name cannot exceed 50 characters';
      } else if (!RegExp(r'^[a-zA-Z\s-]+$').hasMatch(name)) {
        _nameError = 'Only letters, spaces, and hyphens are allowed';
      } else {
        _nameError = null;
      }
    });
  }

  String _capitalizeWords(String input) {
    if (input.isEmpty) return input;
    return input
        .split(' ')
        .map(
          (word) => word.isNotEmpty
              ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}'
              : word,
        )
        .join(' ');
  }

  void _handleNext() {
    _validateName();
    if (_nameError == null) {
      final name = _capitalizeWords(_nameController.text.trim());
      final user = UserEntity(
        name: name,
        profileImagePath: '',
        selectedCategories: [],
      );
      context.read<UserCubit>().saveUser(user);
      Navigator.pushNamed(context, RouteNames.setupImage, arguments: name);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final height = constraints.maxHeight;
        final width = constraints.maxWidth;
        final isTablet = width > 600;

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isTablet ? width * 0.1 : width * 0.08,
                vertical: isTablet ? height * 0.05 : height * 0.03,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: height),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: height * 0.03),

                    Center(
                      child: SvgPicture.asset(
                        'assets/images/logo_app.svg',
                        height: isTablet ? height * 0.15 : height * 0.1,
                        width: isTablet ? width * 0.3 : width * 0.2,
                      ),
                    ),

                    SizedBox(height: isTablet ? height * 0.06 : height * 0.05),

                    Text(
                      "Hi, Welcome to",
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: isTablet ? 36 : 30,
                          ),
                    ),
                    Text(
                      "Expense Tracker",
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: isTablet ? 48 : 40,
                          ),
                    ),

                    SizedBox(height: isTablet ? height * 0.05 : height * 0.04),

                    Text(
                      "What should I call you buddy?",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                        fontSize: isTablet ? 30 : 25,
                      ),
                    ),

                    SizedBox(height: isTablet ? height * 0.02 : height * 0.015),

                    TextField(
                      controller: _nameController,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.black,
                        fontSize: isTablet ? 28 : 23,
                        fontWeight: FontWeight.bold,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'[a-zA-Z\s-]'),
                        ),
                        TextInputFormatter.withFunction((oldValue, newValue) {
                          return TextEditingValue(
                            text: _capitalizeWords(newValue.text),
                            selection: newValue.selection,
                          );
                        }),
                      ],
                      decoration: InputDecoration(
                        hintText: "Name",
                        hintStyle: Theme.of(context).textTheme.bodyMedium
                            ?.copyWith(
                              color: Colors.black54,
                              fontSize: isTablet ? 28 : 23,
                            ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: isTablet ? height * 0.025 : height * 0.02,
                          horizontal: isTablet ? width * 0.05 : width * 0.04,
                        ),
                        filled: true,
                        fillColor: const Color.fromARGB(255, 204, 195, 111),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Colors.white24,
                            width: 2,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: _nameError != null
                                ? Colors.redAccent
                                : Colors.white24,
                            width: 2,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: _nameError != null
                                ? Colors.redAccent
                                : Theme.of(context).primaryColor,
                            width: 2,
                          ),
                        ),
                        errorText: _nameError,
                        errorStyle: TextStyle(
                          color: Colors.redAccent,
                          fontSize: isTablet ? 16 : 14,
                        ),
                      ),
                      onChanged: (value) => _validateName(),
                    ),

                    if (_nameError != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, left: 12.0),
                        child: Text(
                          'Accepted: Letters, spaces, hyphens (2-50 characters)',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: isTablet ? 14 : 12,
                          ),
                        ),
                      ),

                    SizedBox(height: isTablet ? height * 0.04 : height * 0.03),

                    BackNextButtons(
                      onBack: () {}, // or Navigator.pop if needed
                      onNext: _handleNext,
                      showBack: false,
                      nextText: "Next",
                    ),

                    SizedBox(height: isTablet ? height * 0.04 : height * 0.03),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
