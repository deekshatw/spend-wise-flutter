import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spend_wise/core/shared_prefs/shared_prefs.dart';
import 'package:spend_wise/core/utils/utils.dart';
import 'package:spend_wise/features/home/presentation/screens/home_screen.dart';
import 'package:spend_wise/features/transactions/data/models/category.dart';
import 'package:spend_wise/features/transactions/data/models/transaction.dart';
import 'package:http/http.dart' as http;
import 'package:spend_wise/features/transactions/data/models/transaction_summary.dart';

class TransactionRepo {
  static Future<List<Transaction>> getTransactions(
      String type, String startDate, String endDate) async {
    String? token = await SharedPrefs.getUserTokenSharedPreference();

    final String suffixUrl;
    suffixUrl =
        getSuffixUrl(type: type, startDate: startDate, endDate: endDate);
    String url = '${Utils.BASE_URL}transaction$suffixUrl';
    print(url);
    try {
      final response = await http.get(Uri.parse(url), headers: {
        'Authorization': 'Bearer $token',
      });
      print(response.body);
      if (response.statusCode == 200) {
        print('Transactions fetched successfully');
        List<Transaction> transactions = [];
        for (var transaction in jsonDecode(response.body)['data']) {
          transactions.add(Transaction.fromJson(transaction));
        }
        return transactions;
      } else {
        print('Transactions fetch failed');
        return [];
      }
    } catch (err) {
      print('Transactions fetch failed: $err');
      return [];
    }
  }

  static Future<TransactionSummary> fetchTransactionSummary() async {
    String? token = await SharedPrefs.getUserTokenSharedPreference();

    String url = '${Utils.BASE_URL}transaction/summary';
    print(url);
    try {
      final response = await http.get(Uri.parse(url), headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      });
      print(response.body);
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse =
            jsonDecode(response.body)['data'];

        final TransactionSummary summary =
            TransactionSummary.fromJson(jsonResponse);

        return summary;
      } else {
        print('Transaction summary fetch failed');
        return TransactionSummary(income: 0, expense: 0, balance: 0);
      }
    } catch (err) {
      print('Transaction summary fetch failed: $err');
      return TransactionSummary(income: 0, expense: 0, balance: 0);
    }
  }

  static Future<List<Category>> fetchCategories() async {
    String? token = await SharedPrefs.getUserTokenSharedPreference();

    String url = '${Utils.BASE_URL}category/list';
    print(url);
    try {
      final response = await http.get(Uri.parse(url), headers: {
        'Authorization': 'Bearer $token',
      });
      print(response.body);
      if (response.statusCode == 200) {
        print('Categories fetched successfully');
        List<Category> categories = [];
        for (var category in jsonDecode(response.body)['categories']) {
          categories.add(Category.fromJson(category));
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

  static Future<bool> addCategory(
      Map<String, dynamic> body, BuildContext context) async {
    String? token = await SharedPrefs.getUserTokenSharedPreference();

    String url = '${Utils.BASE_URL}category/create';
    print(body);
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );
      print(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text('Category added successfully'),
          ),
        );
        Navigator.pop(context);

        print('Category added successfully');
        return true;
      } else {
        print('Category add failed');
        return false;
      }
    } catch (err) {
      print('Category add failed: $err');
      return false;
    }
  }

  static Future<bool> addTransaction(
      Map<String, dynamic> body, BuildContext context) async {
    String url = '${Utils.BASE_URL}transaction/create';
    print(url);
    print(jsonEncode(body));
    try {
      final response = await http.post(Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode(body));
      print(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text('Transaction added successfully'),
          ),
        );
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (_) => const HomeScreen(
                      initialIndex: 1,
                    )));
        print('Transaction added successfully');
        return true;
      } else {
        print('Transaction add failed');
        return false;
      }
    } catch (err) {
      print('Transaction add failed: $err');
      return false;
    }
  }
}

String getSuffixUrl({
  required String type,
  required String startDate,
  required String endDate,
}) {
  List<String> queryParameters = [];

  // Add parameters only if they are not null and not empty
  if (type != "null" && type.isNotEmpty && type != 'all') {
    queryParameters.add('type=$type');
  }
  if (startDate != "null" && startDate.isNotEmpty) {
    queryParameters.add('startDate=$startDate');
  }
  if (endDate != "null" && endDate.isNotEmpty) {
    queryParameters.add('endDate=$endDate');
  }

  // Return the query string or an empty string if no parameters
  return queryParameters.isNotEmpty ? '?' + queryParameters.join('&') : '';
}
