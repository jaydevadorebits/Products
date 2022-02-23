class Products {
  String? id;
  String? name;
  String? description;
  String? category;
  String? price;

  Products({this.id, this.name, this.description, this.category, this.price});

  Products.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    category = json['category'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['category'] = this.category;
    data['price'] = this.price;

    return data;
  }
}
