import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:spend_wise/core/utils/colors.dart';
import 'package:spend_wise/features/budgets/presentation/screens/budgets_screen.dart';
import 'package:spend_wise/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:spend_wise/features/goals/presentation/screens/goals_screen.dart';
import 'package:spend_wise/features/home/presentation/widgets/menu_item_icon.dart';
import 'package:spend_wise/features/profile/presentation/screens/profile_screen.dart';
import 'package:spend_wise/features/transactions/presentation/screens/transactions_screen.dart';

class HomeScreen extends StatefulWidget {
  final int initialIndex;

  const HomeScreen({super.key, this.initialIndex = 0});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late int _selectedIndex;

  static const List<Widget> _widgetOptions = <Widget>[
    DashboardScreen(),
    TransactionsScreen(),
    BudgetsScreen(),
    GoalsScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
        selectedItemColor: AppColors.primary,
        showUnselectedLabels: true,
        unselectedItemColor: AppColors.charcoal.withOpacity(0.7),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: MenuItemIcon(
              isSelected: _selectedIndex == 0,
              icon: HugeIcons.strokeRoundedHome01,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: MenuItemIcon(
              isSelected: _selectedIndex == 1,
              icon: HugeIcons.strokeRoundedSquareArrowDataTransferHorizontal,
            ),
            label: 'Activity',
          ),
          BottomNavigationBarItem(
            icon: MenuItemIcon(
              isSelected: _selectedIndex == 2,
              icon: HugeIcons.strokeRoundedMoneyReceiveCircle,
            ),
            label: 'Budgets',
          ),
          BottomNavigationBarItem(
            icon: MenuItemIcon(
              isSelected: _selectedIndex == 3,
              icon: HugeIcons.strokeRoundedPiggyBank,
            ),
            label: 'Goals',
          ),
          BottomNavigationBarItem(
            icon: MenuItemIcon(
              isSelected: _selectedIndex == 4,
              icon: HugeIcons.strokeRoundedUser,
            ),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
    );
  }
}
