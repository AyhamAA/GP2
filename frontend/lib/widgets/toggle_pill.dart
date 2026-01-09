import 'package:flutter/material.dart';
import '../theme/colors.dart';

class TogglePill extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const TogglePill({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? kTeal : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: kTeal),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : kTeal,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
