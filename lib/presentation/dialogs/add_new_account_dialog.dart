import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../../domain/entities/account_entity.dart';
import '../cubits/account_cubit/account_cubit.dart';

class AddNewAccountDialog extends StatefulWidget {
  const AddNewAccountDialog({super.key});

  @override
  State<AddNewAccountDialog> createState() => _AddNewAccountDialogState();
}

class _AddNewAccountDialogState extends State<AddNewAccountDialog> {
  final _cardHolderController = TextEditingController();
  final _accountNameController = TextEditingController();
  final _amountController = TextEditingController();

  bool isDefault = false;
  bool isExcluded = false;

  Color pickerColor = const Color(0xfffdd835); // Default Yellow
  Color currentColor = const Color(0xfffdd835);

  void _changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  void _openColorPicker() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Pick a color!'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: pickerColor,
            onColorChanged: _changeColor,
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              setState(() => currentColor = pickerColor);
              Navigator.of(context).pop();
            },
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 30,
        top: 20,
        left: 20,
        right: 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
                Text(
                  "Add Account",
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.help_outline),
                  onPressed: () {},
                ),
              ],
            ),

            const SizedBox(height: 10),

            _buildField(_cardHolderController, "Cardholder Name"),
            const SizedBox(height: 12),
            _buildField(_accountNameController, "Bank Name"),
            const SizedBox(height: 12),
            _buildField(_amountController, "Enter Amount"),
            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Pick Color",
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),

                GestureDetector(
                  onTap: _openColorPicker,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: currentColor, width: 3),
                    ),
                    child: CircleAvatar(
                      radius: 14,
                      backgroundColor: currentColor,
                    ),
                  ),
                ),
              ],
            ),

            Text(
              "Set color to your category",
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.white70,
              ),
            ),

            // Pick Color Section
            const SizedBox(height: 24),

            SwitchListTile(
              value: isDefault,
              onChanged: (v) => setState(() => isDefault = v),
              title: const Text("Default Account"),
              activeColor: currentColor, // ← Use the user's picked color
            ),
            SwitchListTile(
              value: isExcluded,
              onChanged: (v) => setState(() => isExcluded = v),
              title: const Text("Exclude Account"),
              activeColor: currentColor, // ← Apply same here too
            ),

            const SizedBox(height: 24),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    final cardholder = _cardHolderController.text.trim();
                    final accountName = _accountNameController.text.trim();
                    final amount =
                        double.tryParse(_amountController.text.trim()) ?? 0;

                    if (accountName.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please enter a bank name"),
                        ),
                      );
                      return;
                    }

                    final account = AccountEntity(
                      id: DateTime.now().millisecondsSinceEpoch,
                      name: accountName,
                      balance: amount,
                      colorHex: currentColor.value,
                      isSelected: false,
                      isDefault: isDefault,
                      isExcluded: isExcluded,
                    );

                    context.read<AccountCubit>().addAccount(account);
                    Navigator.pop(context);
                  },

                  child: const Text("Add"),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildField(TextEditingController controller, String hint) {
    final theme = Theme.of(context);
    return TextField(
      controller: controller,
      style: theme.textTheme.bodyMedium?.copyWith(
        color: theme.primaryColor,
        fontSize: 23,
        fontWeight: FontWeight.bold,
      ),
      decoration: InputDecoration(
        hintText: hint,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 16,
        ),
      ),
    );
  }
}
