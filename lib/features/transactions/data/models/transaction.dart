class Transaction {
  String? transactionId;
  int? amount;
  String? description;
  String? date;
  String? userId;
  Category? category;
  String? transactionType;

  Transaction(
      {this.transactionId,
      this.amount,
      this.description,
      this.date,
      this.userId,
      this.category,
      this.transactionType});

  Transaction.fromJson(Map<String, dynamic> json) {
    transactionId = json['transactionId'];
    amount = json['amount'];
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

class Category {
  String? categoryId;
  String? name;
  String? description;

  Category({this.categoryId, this.name, this.description});

  Category.fromJson(Map<String, dynamic> json) {
    categoryId = json['categoryId'];
    name = json['name'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['categoryId'] = this.categoryId;
    data['name'] = this.name;
    data['description'] = this.description;
    return data;
  }
}
