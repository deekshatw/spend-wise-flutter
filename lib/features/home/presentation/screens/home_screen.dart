import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spend_wise/core/utils/colors.dart';
import 'package:spend_wise/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:spend_wise/features/profile/presentation/screens/profile_screen.dart';
import 'package:spend_wise/features/transactions/presentation/screens/transactions_screen.dart';

class HomeScreen extends StatefulWidget {
  final int initialIndex; // Add this parameter

  const HomeScreen(
      {super.key, this.initialIndex = 0}); // Default to 0 (Dashboard)

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late int _selectedIndex; // Use late initialization

  static const List<Widget> _widgetOptions = <Widget>[
    DashboardScreen(),
    TransactionsScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    // Set the initial index based on the passed parameter
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
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
        selectedItemColor: AppColors.primary,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.monetization_on),
            label: 'Transactions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
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
