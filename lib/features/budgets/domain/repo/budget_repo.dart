import 'dart:convert';

import 'package:spend_wise/core/shared_prefs/shared_prefs.dart';
import 'package:spend_wise/core/utils/utils.dart';
import 'package:spend_wise/features/budgets/data/models/budget_model.dart';
import 'package:http/http.dart' as http;

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
        print('Categories fetched successfully');
        for (var category in jsonDecode(response.body)['data']) {
          categories.add(BudgetModel.fromJson(category));
        }
        print(categories.first);
        return categories;
      } else {
        print('Categories fetch failed');
        return [];
      }
    } catch (err) {
      print('Categories fetch failed: $err');
      return [];
    }
  }
}
