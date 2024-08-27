import 'package:flutter/material.dart';
import 'package:spend_wise/core/utils/colors.dart';

class LabelWidget extends StatelessWidget {
  final String label;
  const LabelWidget({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        label,
        style: TextStyle(
          color: AppColors.charcoal,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
