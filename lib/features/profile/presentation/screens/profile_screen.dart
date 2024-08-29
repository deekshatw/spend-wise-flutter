import 'package:flutter/material.dart';
import 'package:spend_wise/core/shared_prefs/shared_prefs.dart';
import 'package:spend_wise/core/widgets/primary_button.dart';
import 'package:spend_wise/features/auth/presentation/screens/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: PrimaryButton(
        label: 'Logout',
        onTap: () {
          SharedPrefs.clearUserSharedPreferences();
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => LoginScreen()));
        },
      ),
    );
  }
}
