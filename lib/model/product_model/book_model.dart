/*
class Book{
  String id;
  String price;
  String adTitle;
  String description;
  String productType;
  String subProductType;
  String productName;
  String subProductName;

  Book({
    required this.id,
    required this.price,
    required this.adTitle,
    required this.description,
    required this.productType,
    required this.subProductType,
    required this.productName,
    required this.subProductName
});

  factory Book.fromJson(Map<String,dynamic> data){
    return Book(
        id: data['_id'],
        price: data['price'],
        adTitle: data['adTitle'],
        description: data['description'],
        productType: data['productType']['_id'],
        subProductType: data['subProductType']['_id'],
        productName: data['productType']['name'],
        subProductName: data['subProductType']['name']
    );
  }
}*/

import 'package:admin_panel/model/product_model/product.dart';
import '../user_model/user_model.dart';
class BookModel extends ProductModel {
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
  @override
  @override
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

  BookModel({
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
  })  : super(
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

  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
      id: json['_id'] ?? '',
      price: json['price'],
      adTitle: json['adTitle'],
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
