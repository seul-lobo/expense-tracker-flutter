import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../../domain/entities/user_entity.dart';
import '../../routing/route_names.dart';
import '../cubits/user_cubit/user_state.dart';
import '../dialogs/back_next_buttons.dart';
import '../cubits/user_cubit/user_cubit.dart';

class SetImageScreen extends StatefulWidget {
  const SetImageScreen({super.key});

  @override
  State<SetImageScreen> createState() => _SetImageScreenState();
}

class _SetImageScreenState extends State<SetImageScreen> {
  File? _selectedImage;
  String? userName;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    userName = ModalRoute.of(context)?.settings.arguments as String?;
  }

  Future<String?> _saveImagePermanently(XFile pickedFile) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final savedImage = await File(
        pickedFile.path,
      ).copy('${appDir.path}/$fileName');
      return savedImage.path;
    } catch (e) {
      print('Error saving image: $e');
      return null;
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final permanentPath = await _saveImagePermanently(picked);
      if (permanentPath != null) {
        setState(() {
          _selectedImage = File(permanentPath);
        });
      }
    }
  }

  void _showImageRequiredDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: const Text(
          'Image Required',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Please select a profile image before proceeding.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK', style: TextStyle(color: Colors.amber)),
          ),
        ],
      ),
    );
  }

  void _handleNext() {
    if (_selectedImage == null) {
      _showImageRequiredDialog();
      return;
    }

    final userCubit = context.read<UserCubit>();
    final state = userCubit.state;

    if (state is UserLoaded) {
      final updatedUser = UserEntity(
        name: state.user.name,
        profileImagePath: _selectedImage!.path,
        selectedCategories: [],
      );
      print("✅ Saving user with image: ${_selectedImage!.path}");
      userCubit.saveUser(updatedUser);
    }

    Navigator.pushNamed(context, RouteNames.accountSelection);
  }

  void _handleBack() {
    Navigator.pop(context);
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
                vertical: isTablet ? height * 0.04 : height * 0.02,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: height),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: height * 0.02),
                    GestureDetector(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: isTablet ? height * 0.14 : height * 0.11,
                        backgroundColor: Theme.of(context).primaryColor,
                        backgroundImage: _selectedImage != null
                            ? FileImage(_selectedImage!)
                            : null,
                        child: _selectedImage == null
                            ? Icon(
                                Icons.camera_alt,
                                size: isTablet ? height * 0.08 : height * 0.06,
                                color: Colors.white,
                              )
                            : null,
                      ),
                    ),
                    SizedBox(height: isTablet ? height * 0.05 : height * 0.04),
                    Text(
                      "Image Selection",
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: isTablet ? 44 : 36,
                          ),
                    ),
                    SizedBox(height: isTablet ? height * 0.03 : height * 0.02),
                    Text(
                      "Let's set an image of you",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                        fontSize: isTablet ? 28 : 24,
                      ),
                    ),
                    SizedBox(height: isTablet ? height * 0.03 : height * 0.02),
                    BackNextButtons(
                      onBack: _handleBack,
                      onNext: _handleNext,
                      showBack: true,
                      nextText: "Next",
                      backText: "Back",
                    ),
                    SizedBox(height: isTablet ? height * 0.03 : height * 0.02),
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
