import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/models/debt_model.dart';
import '../../domain/entities/account_entity.dart';
import '../cubits/account_cubit/account_cubit.dart';
import '../cubits/debt_cubit/debt_cubit.dart';

class AddDebtScreen extends StatefulWidget {
  const AddDebtScreen({super.key});

  @override
  State<AddDebtScreen> createState() => _AddDebtScreenState();
}

class _AddDebtScreenState extends State<AddDebtScreen> {
  String selectedType = '';
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  DateTime selectedDate = DateTime.now();

  void _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) setState(() => selectedDate = picked);
  }

  void _showError(String msg) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.black,
        title: const Text(
          "Validation Error",
          style: TextStyle(color: Colors.white),
        ),
        content: Text(msg, style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK", style: TextStyle(color: Colors.amber)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.white),
        title: const Text(
          "Add Debt / Credit",
          style: TextStyle(color: Colors.white),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(color: Colors.white10, height: 1),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 10,
              children: ['Debt', 'Credit'].map((type) {
                final isSelected = selectedType == type;
                return ChoiceChip(
                  label: Text(type),
                  selected: isSelected,
                  onSelected: (_) {
                    setState(() {
                      selectedType = isSelected ? '' : type;
                    });
                  },
                  selectedColor: Colors.black,
                  backgroundColor: const Color.fromARGB(
                    255,
                    204,
                    195,
                    111,
                  ).withOpacity(0.8),
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            _buildTextField("Title", _nameController),
            const SizedBox(height: 16),
            _buildTextField("Amount", _amountController, isNumber: true),
            const SizedBox(height: 16),
            _buildTextField("Description", _descriptionController),
            const SizedBox(height: 24),

            ElevatedButton.icon(
              onPressed: _pickDate,
              icon: const Icon(Icons.calendar_today, color: Colors.white),
              label: Text(
                "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  final title = _nameController.text.trim();
                  final amount = _amountController.text.trim();

                  if (title.isEmpty || amount.isEmpty || selectedType.isEmpty) {
                    _showError("Please fill in all fields and select type.");
                    return;
                  }

                  final parsedAmount = double.tryParse(amount);
                  if (parsedAmount == null || parsedAmount <= 0) {
                    _showError("Enter a valid amount.");
                    return;
                  }

                  final isDebt = selectedType == 'Debt';
                  final accountsState = context.read<AccountCubit>().state;
                  AccountEntity? selectedAccount;

                  if (accountsState is AccountLoaded) {
                    selectedAccount = accountsState.accounts.firstWhere(
                      (acc) => acc.isSelected,
                      orElse: () => accountsState.accounts.isNotEmpty
                          ? accountsState.accounts.first
                          : throw Exception('No accounts available'),
                    );
                  } else {
                    _showError(
                      "No accounts loaded. Please add an account first.",
                    );
                    return;
                  }

                  final debtCredit = DebtModel(
                    name: title,
                    amount: parsedAmount,
                    description: _descriptionController.text.trim(),
                    dueDate: selectedDate,
                    isDebt: isDebt,
                    accountId: selectedAccount.id, // Ensured non-null
                  );

                  context.read<DebtCubit>().addDebt(debtCredit);

                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: const Text(
                  "Add",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    bool isNumber = false,
  }) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      decoration: InputDecoration(
        hintText: label,
        filled: true,
        fillColor: const Color.fromARGB(255, 204, 195, 111),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(12),
        ),
        hintStyle: GoogleFonts.karla(color: Colors.black38),
      ),
    );
  }
}
