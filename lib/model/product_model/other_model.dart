import 'package:admin_panel/model/product_model/product.dart';
import '../user_model/user_model.dart';

class OtherModel extends ProductModel {
  @override
  String id;
  @override
  List<dynamic> price;
  @override
  List<dynamic> adTitle;
  @override
  List<dynamic> description;
  @override
  List<dynamic> images;
  String productType;
  String subProductType;
  @override
  String productName;
  String subProductName;
  @override
  String category;
  @override
  String modelName;
  final UserModel user;
  String timestamps;
  bool isActive = true;
  bool isDeleted = false;
  List<String> street1;
  List<String> street2;
  List<String> area;
  List<String> city;
  List<String> state;
  List<String> country;
  List<String> pincode;
  OtherModel({
    required this.id,
    required this.price,
    required this.adTitle,
    required this.description,
    required this.images,
    required this.productType,
    required this.subProductType,
    required this.productName,
    required this.subProductName,
    required this.category,
    required this.modelName,
    required this.user,
    required this.timestamps,
    required this.isActive,
    required this.isDeleted,
    required this.street1,
    required this.street2,
    required this.area,
    required this.city,
    required this.state,
    required this.country,
    required this.pincode,
  }): super(
    id: id,
    price: price,
    adTitle: adTitle,
    description: description,
    images: images,
    modelName: modelName,
    productName: productName,
    category: category,
   user: user
  );

  factory OtherModel.fromJson(Map<String, dynamic> json) {
    return OtherModel(
      id: json['_id'] ?? '',
      price: json['price'] is List ? json['price'] : [],
      adTitle: json['adTitle'] is List ? json['adTitle'] : [],
      description: json['description'] is List ? json['description'] : [],
      images: json['images'] is List ? json['images'] : [],
      productType: json['productType']?['_id'] ?? '',
      subProductType: json['subProductType']?['_id'] ?? '',
      productName: json['productType']?['name'] ?? '',
      subProductName: json['subProductType']?['name'] ?? '',
      category: json['categories'] ?? '',
      modelName: json['productType']?['modelName'] ?? '',
      user: json['userId'] != null && json['userId'] is Map
          ? UserModel.fromJson(json['userId'])
          : throw Exception('UserModel cannot be null'),
      timestamps: json['createdAt'] ?? '',
      isActive: json['isActive'] ?? true,
      isDeleted: json['isDeleted'] ?? false,
        street1: List<String>.from(json['street1'] ?? []),
        street2: List<String>.from(json['street2'] ?? []),
        area: List<String>.from(json['area'] ?? []),
        city: List<String>.from(json['city'] ?? []),
        state: List<String>.from(json['state'] ?? []),
        country: List<String>.from(json['country'] ?? []),
        pincode: List<String>.from(json['pinCode'] ?? [])
    );
  }

/*factory OtherModel.fromJson(Map<String, dynamic> json) {
    return OtherModel(
      id: json['_id'] ?? '',
      price: json['price'],
      adTitle: json['title'],
      description: json['description'],
      images:json['images'] is List ? json['images'] : [],
      productType: json['productType']?['_id'] ?? '',
      subProductType: json['subProductType']?['_id'] ?? '',
      productName: json['productType']?['name'] ?? '',
      subProductName: json['subProductType']?['name'] ?? '',
      category: json['categories'] ?? '',
      modelName: json['productType']?['modelName'] ?? '',
      user: json['userId'] != null && json['userId'] is Map
          ? UserModel.fromJson(json['userId'])
          : throw Exception('UserModel cannot be null'),
      timestamps: json['createdAt'] ?? '',
      isActive: json['isActive'] ?? true,
      isDeleted: json['isDeleted'] ?? false,

    );
  }*/
}
