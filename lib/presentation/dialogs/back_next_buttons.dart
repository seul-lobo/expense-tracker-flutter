import 'package:flutter/material.dart';

class BackNextButtons extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onNext;
  final bool showBack;
  final String nextText;
  final String backText;

  const BackNextButtons({
    super.key,
    required this.onNext,
    required this.onBack,
    this.showBack = true,
    this.nextText = "Next",
    this.backText = "Back",
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.only(top: height * 0.02, bottom: height * 0.03),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (showBack)
            ElevatedButton.icon(
              onPressed: onBack,
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              label: Text(
                backText,
                style: const TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[700],
                padding: EdgeInsets.symmetric(
                  vertical: height * 0.017,
                  horizontal: width * 0.05,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ElevatedButton.icon(
            onPressed: onNext,
            icon: const Icon(Icons.arrow_forward, color: Colors.white),
            label: Text(nextText, style: const TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.primaryColor,
              padding: EdgeInsets.symmetric(
                vertical: height * 0.017,
                horizontal: width * 0.05,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
