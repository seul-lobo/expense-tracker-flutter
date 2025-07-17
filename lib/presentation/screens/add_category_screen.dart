import 'package:flutter/material.dart';

class AddCategoryScreen extends StatefulWidget {
  const AddCategoryScreen({super.key});

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  final _nameController = TextEditingController();
  final _descController = TextEditingController();

  Color selectedColor = Colors.yellow;
  bool hasBudget = false;
  bool isTransfer = false;

  void _handleSubmit() {
    if (_nameController.text.isEmpty) {
      _showError("Category name is required");
      return;
    }

    // Submit logic here
    Navigator.pop(context);
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.black,
        title: const Text('Error', style: TextStyle(color: Colors.white)),
        content: Text(message, style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK', style: TextStyle(color: Colors.amber)),
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
        title: const Text("Add Category", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.white),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(color: Colors.white10, height: 1),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(hintText: "Category Name"),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descController,
              decoration: const InputDecoration(hintText: "Description"),
            ),
            const SizedBox(height: 24),

            /// Icon Picker (Placeholder)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.black45,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                children: [
                  Icon(Icons.category, color: Colors.white),
                  SizedBox(width: 12),
                  Text("Select Icon", style: TextStyle(color: Colors.white)),
                ],
              ),
            ),

            const SizedBox(height: 24),

            /// Color Picker
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Pick Color", style: TextStyle(color: Colors.white, fontSize: 16)),
                GestureDetector(
                  onTap: () {
                    // Later use Color Picker dialog
                  },
                  child: CircleAvatar(
                    backgroundColor: selectedColor,
                    radius: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            SwitchListTile(
              title: const Text("Budget", style: TextStyle(color: Colors.white)),
              value: hasBudget,
              onChanged: (val) => setState(() => hasBudget = val),
              activeColor: Colors.amber,
            ),
            SwitchListTile(
              title: const Text("Transfer Category", style: TextStyle(color: Colors.white)),
              value: isTransfer,
              onChanged: (val) => setState(() => isTransfer = val),
              activeColor: Colors.amber,
            ),

            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _handleSubmit,
                child: const Text("Add", style: TextStyle(fontSize: 18)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
