import 'package:admin_panel/model/product_model/product.dart';

import '../user_model/user_model.dart';

class SmartPhoneModel extends ProductModel {
  @override
  String id;
  List<dynamic> brand;
  List<dynamic> model;
  @override
  List<dynamic> price;
  List<dynamic> batteryBackup;
  List<dynamic> year;
  List<dynamic> storage;
  @override
  List<dynamic> adTitle;
  @override
  List<dynamic> description;
  @override
  List<dynamic> images;
  bool isDeleted;
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
  List<String> street1;
  List<String> street2;
  List<String> area;
  List<String> city;
  List<String> state;
  List<String> country;
  List<String> pincode;

  SmartPhoneModel({
    required this.id,
    required this.brand,
    required this.model,
    required this.price,
    required this.batteryBackup,
    required this.year,
    required this.storage,
    required this.adTitle,
    required this.description,
    required this.isDeleted,
    required this.productType,
    required this.subProductType,
    required this.productName,
    required this.subProductName,
    required this.images,
    required this.category,
    required this.modelName,
   required this.user,
    required this.timestamps,
    required this.isActive,
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

  factory SmartPhoneModel.fromJson(Map<String, dynamic> json) {
    return SmartPhoneModel(
      id: json['_id'] ?? '',
      brand: json['brand'],
      model: json['model'],
      price: json['price'],
       images:json['images'] is List ? json['images'] : [],
      batteryBackup: json['batteryBackup'] ?? [],
      year: json['year'] ?? [],
      storage: json['storage'],
      adTitle: json['adTitle'],
      description:json['description'],
      isDeleted: json['isDeleted'] ?? false,
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
        street1: List<String>.from(json['street1'] ?? []),
        street2: List<String>.from(json['street2'] ?? []),
        area: List<String>.from(json['area'] ?? []),
        city: List<String>.from(json['city'] ?? []),
        state: List<String>.from(json['state'] ?? []),
        country: List<String>.from(json['country'] ?? []),
        pincode: List<String>.from(json['pinCode'] ?? [])

    );
  }
}
