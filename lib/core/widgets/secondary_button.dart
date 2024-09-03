import 'package:flutter/material.dart';
import 'package:spend_wise/core/utils/colors.dart';

class SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  const SecondaryButton({super.key, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary.withOpacity(0.15),
          elevation: 0,
          padding: const EdgeInsets.all(16),
        ),
        onPressed: onTap,
        child: Text(
          label,
          style: const TextStyle(
            color: AppColors.primary,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
