import 'package:spend_wise/features/transactions/data/models/category.dart';

class Transaction {
  String? transactionId;
  int? amount;
  String? title;
  String? description;
  String? date;
  String? userId;
  Category? category;
  String? transactionType;

  Transaction(
      {this.transactionId,
      this.amount,
      this.title,
      this.description,
      this.date,
      this.userId,
      this.category,
      this.transactionType});

  Transaction.fromJson(Map<String, dynamic> json) {
    transactionId = json['transactionId'];
    amount = json['amount'];
    title = json['title'];
    description = json['description'];
    date = json['date'];
    userId = json['userId'];
    category = json['category'] != null
        ? new Category.fromJson(json['category'])
        : null;
    transactionType = json['transactionType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['transactionId'] = this.transactionId;
    data['amount'] = this.amount;
    data['title'] = this.title;
    data['description'] = this.description;
    data['date'] = this.date;
    data['userId'] = this.userId;
    if (this.category != null) {
      data['category'] = this.category!.toJson();
    }
    data['transactionType'] = this.transactionType;
    return data;
  }
}
