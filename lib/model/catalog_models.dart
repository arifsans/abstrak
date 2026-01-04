class CategoryModel {
  String? id;
  String? name;
  String? description;

  CategoryModel({this.id, this.name, this.description});

  CategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    name = json['name'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    return data;
  }
}

class ProductModel {
  String? id;
  String? categoryId;
  String? name;
  num? price;
  String? categoryName;

  ProductModel(
      {this.id, this.categoryId, this.name, this.price, this.categoryName});

  ProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    categoryId = json['category_id'].toString();
    name = json['name'];
    price = num.tryParse(json['price'].toString());
    categoryName = json['category_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['category_id'] = categoryId;
    data['name'] = name;
    data['price'] = price;
    data['category_name'] = categoryName;
    return data;
  }
}

class InventoryStatsModel {
  int? total;
  int? available;
  int? sold;

  InventoryStatsModel({this.total, this.available, this.sold});

  InventoryStatsModel.fromJson(Map<String, dynamic> json) {
    total = int.tryParse(json['total'].toString());
    available = int.tryParse(json['available'].toString());
    sold = int.tryParse(json['sold'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total'] = total;
    data['available'] = available;
    data['sold'] = sold;
    return data;
  }
}

class InventoryItemModel {
  String? id;
  String? productId;
  String? productName;
  String? secretCode;
  String? status;
  String? soldAt;
  String? createdAt;

  InventoryItemModel({
    this.id,
    this.productId,
    this.productName,
    this.secretCode,
    this.status,
    this.soldAt,
    this.createdAt,
  });

  InventoryItemModel.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    productId = json['product_id']?.toString();
    productName = json['product_name'];
    secretCode = json['secret_code'];
    status = json['status'];
    soldAt = json['sold_at'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'product_name': productName,
      'secret_code': secretCode,
      'status': status,
      'sold_at': soldAt,
      'created_at': createdAt,
    };
  }
}
