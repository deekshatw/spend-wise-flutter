import 'package:flutter/cupertino.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:spend_wise/core/utils/colors.dart';

class MenuItemIcon extends StatelessWidget {
  final bool isSelected;
  final IconData icon;
  const MenuItemIcon({super.key, required this.isSelected, required this.icon});

  @override
  Widget build(BuildContext context) {
    return HugeIcon(
      icon: icon,
      color:
          isSelected ? AppColors.primary : AppColors.charcoal.withOpacity(0.7),
      size: MediaQuery.of(context).size.width * 0.06,
    );
  }
}
