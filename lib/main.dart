import 'package:flutter/material.dart';
import 'package:spend_wise/core/utils/colors.dart';
import 'package:spend_wise/features/splash/splash_screen.dart';

void main() {
  runApp(
    MaterialApp(
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: AppColors.primarySwatch,
      ),
    ),
  );
}
