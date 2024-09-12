class BudgetModel {
  String? budgetId;
  dynamic amount;
  dynamic spent;
  dynamic remaining;
  dynamic percentageSpent;
  Category? category;
  String? startDate;
  String? endDate;

  BudgetModel(
      {this.budgetId,
      this.amount,
      this.spent,
      this.remaining,
      this.percentageSpent,
      this.category,
      this.startDate,
      this.endDate});

  BudgetModel.fromJson(Map<String, dynamic> json) {
    budgetId = json['budgetId'];
    amount = json['amount'];
    spent = json['spent'];
    remaining = json['remaining'];
    percentageSpent = json['percentageSpent'];
    category = json['category'] != null
        ? new Category.fromJson(json['category'])
        : null;
    startDate = json['startDate'];
    endDate = json['endDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['budgetId'] = this.budgetId;
    data['amount'] = this.amount;
    data['spent'] = this.spent;
    data['remaining'] = this.remaining;
    data['percentageSpent'] = this.percentageSpent;
    if (this.category != null) {
      data['category'] = this.category!.toJson();
    }
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
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
