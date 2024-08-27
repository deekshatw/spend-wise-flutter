import 'package:flutter/material.dart';
import 'package:spend_wise/core/shared_prefs/shared_prefs.dart';
import 'package:spend_wise/features/auth/presentation/screens/login_screen.dart';
import 'package:spend_wise/features/home/presentation/screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isLoggedIn = false;
  @override
  void initState() {
    // _checkIsLoggedIn();
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (_) => isLoggedIn ? HomeScreen() : LoginScreen()));
    });
    super.initState();
  }

  void _checkIsLoggedIn() async {
    isLoggedIn = await SharedPrefs.getUserTokenSharedPreference() != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Splash Screen'),
      ),
    );
  }
}
