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
    super.initState();
    _checkIsLoggedIn();
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (_) => isLoggedIn ? HomeScreen() : LoginScreen()));
    });
  }

  void _checkIsLoggedIn() async {
    isLoggedIn = await SharedPrefs.getUserTokenSharedPreference() != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Splash screen container with logo/image
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blueGrey.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                height: 60,
                width: 60,
                'assets/images/dead.png', // Make sure the path is correct
              ),
            ),
            SizedBox(height: 20),
            // Optional: Add a text or a loading indicator
            // Optional: add this for a loading effect
          ],
        ),
      ),
    );
  }
}
