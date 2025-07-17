import 'package:expense_tracker/domain/entities/transaction_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../data/models/transaction_model.dart';
import '../cubits/account_cubit/account_cubit.dart';
import '../cubits/transaction_cubit/transaction_cubit.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  String selectedType = "Expense";
  int? selectedAccountId;
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  List<String> categories = [
    'Grocery',
    'Food',
    'Travel',
    'Shopping',
    'Bills',
    'Salary',
  ];
  String? selectedCategory;

  void _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) setState(() => selectedDate = picked);
  }

  void _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null) setState(() => selectedTime = picked);
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black,
        title: const Text(
          "Validation Error",
          style: TextStyle(color: Colors.white),
        ),
        content: Text(message, style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK", style: TextStyle(color: Colors.amber)),
          ),
        ],
      ),
    );
  }

  void _addCategoryDialog() {
    TextEditingController newCategoryController = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.black,
        title: const Text(
          "Add Category",
          style: TextStyle(color: Colors.white),
        ),
        content: TextField(
          controller: newCategoryController,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          decoration: InputDecoration(
            hintText: "Category name",
            hintStyle: GoogleFonts.karla(color: Colors.white54),
            filled: true,
            fillColor: const Color.fromARGB(255, 204, 195, 111),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (newCategoryController.text.isNotEmpty) {
                setState(() {
                  categories.add(newCategoryController.text);
                });
              }
            },
            child: const Text("Add", style: TextStyle(color: Colors.amber)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    String nameHint = selectedType == "Expense"
        ? "Expense Name"
        : selectedType == "Income"
        ? "Income Name"
        : "Transfer Title";

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.white),
        title: const Text(
          'Add Transaction',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(color: Colors.white10, height: 1),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 10,
              children: ['Expense', 'Income', 'Transfer'].map((type) {
                final isSelected = selectedType == type;
                return ChoiceChip(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  label: Text(type),
                  selected: isSelected,
                  onSelected: (_) => setState(() => selectedType = type),
                  selectedColor: Colors.black,
                  backgroundColor: const Color.fromARGB(255, 204, 195, 111),
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            _buildTextField(nameHint, _nameController),
            const SizedBox(height: 16),
            _buildTextField("Amount", _amountController, isNumber: true),
            const SizedBox(height: 16),
            _buildTextField("Description", _descriptionController),
            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: _pickDate,
                  icon: const Icon(Icons.calendar_today, color: Colors.white),
                  label: Text(
                    DateFormat.yMMMd().format(selectedDate),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _pickTime,
                  icon: const Icon(Icons.access_time, color: Colors.white),
                  label: Text(
                    selectedTime.format(context),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            Text(
              "Select Account",
              style: theme.textTheme.bodyLarge?.copyWith(
                color: Colors.white,
                fontSize: 25,
              ),
            ),
            const SizedBox(height: 12),
            BlocBuilder<AccountCubit, AccountState>(
              builder: (context, state) {
                if (state is AccountLoaded) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _accountBox(-1, Icons.add, "Add New", isAdd: true),
                        const SizedBox(width: 12),
                        ...state.accounts.map(
                          (acc) => Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: _accountBox(
                              acc.id,
                              Icons.account_balance_wallet,
                              acc.name,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (state is AccountLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return const Text(
                    "No accounts found",
                    style: TextStyle(color: Colors.white),
                  );
                }
              },
            ),

            const SizedBox(height: 32),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Select Category",
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: Colors.white,
                    fontSize: 25,
                  ),
                ),
                TextButton(
                  onPressed: _addCategoryDialog,
                  child: const Text(
                    "+ Add",
                    style: TextStyle(color: Colors.amber, fontSize: 18),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 50,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final label = categories[index];
                  final isSelected = selectedCategory == label;
                  return GestureDetector(
                    onTap: () => setState(() => selectedCategory = label),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.black
                            : const Color.fromARGB(255, 204, 195, 111),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        label,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 28),

            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                onPressed: () {
                  final name = _nameController.text.trim();
                  final amountText = _amountController.text.trim();

                  if (selectedAccountId == null || selectedAccountId == -1) {
                    _showError("Please select an account.");
                    return;
                  }

                  if (name.isEmpty ||
                      amountText.isEmpty ||
                      selectedCategory == null) {
                    _showError(
                      "Please fill all required fields and select a category.",
                    );
                    return;
                  }

                  final amount = double.tryParse(amountText);
                  if (amount == null || amount <= 0) {
                    _showError(
                      "Please enter a valid positive number for amount.",
                    );
                    return;
                  }

                  final tx = TransactionModel(
                    id: const Uuid().v4(),
                    name: name,
                    amount: amount,
                    description: _descriptionController.text.trim(),
                    type: selectedType,
                    category: selectedCategory!,
                    dateTime: DateTime(
                      selectedDate.year,
                      selectedDate.month,
                      selectedDate.day,
                      selectedTime.hour,
                      selectedTime.minute,
                    ),
                    accountId: selectedAccountId!,
                  );

                  final transactionEntity = TransactionEntity(
                    id: tx.id,
                    name: tx.name,
                    amount: tx.amount,
                    description: tx.description,
                    type: tx.type,
                    category: tx.category,
                    dateTime: tx.dateTime,
                    accountId: tx.accountId,
                  );

                  context.read<TransactionCubit>().addTransaction(
                    transactionEntity,
                  );

                  // 👇 Add this line to update account balance
                  context.read<AccountCubit>().updateBalance(
                    tx.accountId,
                    tx.amount,
                    tx.type == 'Income',
                  );

                  Navigator.pop(context);
                },
                child: const Text(
                  "Add",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
        hintStyle: GoogleFonts.karla(color: Colors.black38),
        filled: true,
        fillColor: const Color.fromARGB(255, 204, 195, 111),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _accountBox(
    int accountId,
    IconData icon,
    String label, {
    bool isAdd = false,
  }) {
    final isSelected = selectedAccountId == accountId;
    final screenWidth = MediaQuery.of(context).size.width;
    final boxWidth = screenWidth * 0.28; // ~28% of screen width
    final iconSize = screenWidth * 0.07; // scales with screen

    return GestureDetector(
      onTap: () {
        if (!isAdd) {
          setState(() {
            selectedAccountId = accountId;
          });
        } else {
          // TODO: Handle adding new account logic
        }
      },
      child: Container(
        height: boxWidth,
        width: boxWidth,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Colors.amber : Colors.white30,
            width: isSelected ? 3 : 1,
          ),
          color: Colors.white10,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: iconSize),
            const SizedBox(height: 8),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                maxLines: 1,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: screenWidth * 0.035,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
