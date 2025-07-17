import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class AddRecurringScreen extends StatefulWidget {
  const AddRecurringScreen({super.key});

  @override
  State<AddRecurringScreen> createState() => _AddRecurringScreenState();
}

class _AddRecurringScreenState extends State<AddRecurringScreen> {
  String selectedType = "Expense";
  String selectedPeriod = "Daily";
  String? selectedAccount;
  String? selectedCategory;

  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  final List<String> periodOptions = ['Daily', 'Weekly', 'Monthly', 'Yearly'];
  final List<String> categories = ['Rent', 'Bills', 'Subscription'];
  final List<String> accounts = ['Cash', 'Bank', 'Wallet'];

  Widget _accountOption(
    String label,
    IconData icon, {
    bool isSelected = false,
    bool isAdd = false,
  }) {
    return GestureDetector(
      onTap: () {
        if (isAdd) {
          Navigator.pushNamed(context, '/add_account');
        } else {
          setState(() => selectedAccount = label);
        }
      },
      child: Container(
        width: 100,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.black
              : const Color.fromARGB(255, 204, 195, 111),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.black,
              size: 28,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
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

  void _showError(String msg) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.black,
        title: const Text('Error', style: TextStyle(color: Colors.white)),
        content: Text(msg, style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            child: const Text("OK", style: TextStyle(color: Colors.amber)),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  void _handleSubmit() {
    if (_titleController.text.isEmpty ||
        _amountController.text.isEmpty ||
        selectedAccount == null ||
        selectedCategory == null) {
      _showError("Please fill all fields and select account and category.");
      return;
    }

    // Submit logic here
    Navigator.pop(context);
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
          "Add Recurring",
          style: TextStyle(color: Colors.white),
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
            // Choice Chips
            Wrap(
              spacing: 10,
              children: ['Expense', 'Income'].map((type) {
                final isSelected = selectedType == type;
                return ChoiceChip(
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

            const SizedBox(height: 10),
            _buildTextField("Title", _titleController),
            const SizedBox(height: 12),
            _buildTextField("Amount", _amountController, isNumber: true),

            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: _pickDate,
                  icon: const Icon(Icons.calendar_today, color: Colors.white),
                  label: Text(
                    DateFormat.yMMMd().format(selectedDate),
                    style: const TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
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
                    style: const TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),
            Text(
              "Repeat Every",
              style: theme.textTheme.bodyLarge?.copyWith(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              children: periodOptions.map((option) {
                final selected = selectedPeriod == option;
                return ChoiceChip(
                  label: Text(option),
                  selected: selected,
                  onSelected: (_) => setState(() => selectedPeriod = option),
                  selectedColor: Colors.black,
                  backgroundColor: const Color.fromARGB(255, 204, 195, 111),
                  labelStyle: TextStyle(
                    color: selected ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 15),
            Text(
              "Select Account",
              style: theme.textTheme.bodyLarge?.copyWith(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _accountOption("Add New", Icons.add, isAdd: true),
                ...accounts.map((account) {
                  final isSelected = selectedAccount == account;
                  return _accountOption(
                    account,
                    Icons.account_balance_wallet,
                    isSelected: isSelected,
                  );
                }),
              ],
            ),

            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Select Category",
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) {
                        final _newCatController = TextEditingController();
                        return AlertDialog(
                          title: const Text("Add Category"),
                          content: TextField(
                            controller: _newCatController,
                            decoration: const InputDecoration(
                              hintText: "Category name",
                            ),
                            style: TextStyle(color: Colors.black),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () {
                                if (_newCatController.text.isNotEmpty) {
                                  setState(() {
                                    categories.add(_newCatController.text);
                                    selectedCategory = _newCatController.text;
                                  });
                                }
                                Navigator.pop(context);
                              },
                              child: const Text("Add"),
                            ),
                          ],
                        );
                      },
                    );
                  },

                  child: const Text(
                    "+ Add",
                    style: TextStyle(color: Colors.amber),
                  ),
                ),
              ],
            ),

            Wrap(
              spacing: 10,
              children: categories.map((cat) {
                final selected = selectedCategory == cat;
                return ChoiceChip(
                  label: Text(cat),
                  selected: selected,
                  onSelected: (_) => setState(() => selectedCategory = cat),
                  selectedColor: Colors.black,
                  backgroundColor: const Color.fromARGB(255, 204, 195, 111),
                  labelStyle: TextStyle(
                    color: selected ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: _handleSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
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
}
