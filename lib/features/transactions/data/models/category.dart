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
