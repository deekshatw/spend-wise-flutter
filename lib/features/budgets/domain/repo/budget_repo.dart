import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:spend_wise/core/shared_prefs/shared_prefs.dart';
import 'package:spend_wise/core/utils/utils.dart';
import 'package:spend_wise/features/budgets/data/models/budget_model.dart';
import 'package:http/http.dart' as http;
import 'package:spend_wise/features/home/presentation/screens/home_screen.dart';

class BudgetRepo {
  static Future<List<BudgetModel>> fetchBudgets() async {
    String? token = await SharedPrefs.getUserTokenSharedPreference();

    String url = '${Utils.BASE_URL}budget/all';
    List<BudgetModel> categories = [];

    print(url);
    try {
      final response = await http.get(Uri.parse(url), headers: {
        'Authorization': 'Bearer $token',
      });
      print(response.body);
      if (response.statusCode == 200) {
        print('Budgets fetched successfully');
        for (var category in jsonDecode(response.body)['data']) {
          categories.add(BudgetModel.fromJson(category));
        }
        print(categories.first);
        return categories;
      } else {
        print('Budgets fetch failed');
        return [];
      }
    } catch (err) {
      // throw Exception('Budgets fetch failed: $err');
      return [];
    }
  }

  Future<bool> addbudget(
      Map<String, dynamic> body, BuildContext context) async {
    String? token = await SharedPrefs.getUserTokenSharedPreference();

    String url = '${Utils.BASE_URL}budget/create';
    print(url);
    print(jsonEncode(body));
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );
      print(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text('Budget added successfully'),
          ),
        );
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (_) => const HomeScreen(
                      initialIndex: 2,
                    )));
        print('Budget added successfully');
        return true;
      } else {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text(jsonDecode(response.body)['message']),
          ),
        );
        print('Budget add failed');
        return false;
      }
    } catch (err) {
      print('Budget add failed: $err');
      return false;
    }
  }
}
