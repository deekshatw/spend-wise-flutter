import 'dart:convert';

import 'package:spend_wise/core/shared_prefs/shared_prefs.dart';
import 'package:spend_wise/core/utils/utils.dart';
import 'package:spend_wise/features/transactions/data/models/transaction.dart';
import 'package:http/http.dart' as http;

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
