import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:spend_wise/core/shared_prefs/shared_prefs.dart';
import 'package:spend_wise/core/utils/utils.dart';
import 'package:http/http.dart' as http;
import 'package:spend_wise/features/auth/presentation/screens/login_screen.dart';
import 'package:spend_wise/features/home/presentation/screens/home_screen.dart';

class AuthRepo {
  static Future<bool> loginUser(
      String email, String password, BuildContext context) async {
    String url = '${Utils.BASE_URL}auth/login';
    print(url);
    Map<String, String> body = {
      'email': email,
      'password': password,
    };
    try {
      final response = await http.post(Uri.parse(url), body: body);
      print(response.body);
      if (response.statusCode == 200) {
        print('Login successful');
        SharedPrefs.saveUserTokenSharedPreference(
            jsonDecode(response.body)['user']['token']);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const HomeScreen()));
        return true;
      } else {
        print('Login failed');
        return false;
      }
    } catch (err) {
      print('Login failed: $err');
      return false;
    }
  }

  static Future<bool> registerUser(
      String name, String email, String password, BuildContext context) async {
    String url = '${Utils.BASE_URL}auth/register';
    print(url);
    Map<String, String> body = {
      'name': name,
      'email': email,
      'password': password,
    };
    try {
      final response = await http.post(Uri.parse(url), body: body);
      print(response.body);
      if (response.statusCode == 201 || response.statusCode == 200) {
        print('Registration successful');

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const LoginScreen()));
        return true;
      } else {
        print('Registration failed');
        return false;
      }
    } catch (err) {
      print('Registration failed: $err');
      return false;
    }
  }
}
