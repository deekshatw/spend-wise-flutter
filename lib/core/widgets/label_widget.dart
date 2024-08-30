import 'package:flutter/material.dart';
import 'package:spend_wise/core/utils/colors.dart';

class LabelWidget extends StatelessWidget {
  final String label;
  final bool isRequired;
  const LabelWidget({super.key, required this.label, this.isRequired = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              color: AppColors.charcoal,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (isRequired)
            Text(
              ' *',
              style: TextStyle(
                color: Colors.red,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
        ],
      ),
    );
  }
}
