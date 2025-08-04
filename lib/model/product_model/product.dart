/*
abstract class ProductModel {
  String id;
  List<String> price;
  List<String> adTitle;
  List<String> description;
  List<String> images;
  String modelName;
  String productName;
  String category;
List<String> address1;
  List<String> address2;
  List<String> address3;

  ProductModel({
    required this.id,
    required this.price,
    required this.adTitle,
    required this.description,
    required this.images,
    required this.modelName,
    required this.productName,
    required this.category,
    required this.address2,
    required this.address1,
    required this.address3

  });
}*/


import '../user_model/user_model.dart';

abstract class ProductModel {
   String id;
   List<dynamic> price;
   List<dynamic> adTitle;
   List<dynamic> description;
  List<dynamic> images;
   String modelName;
   String productName;
   String category;
   UserModel user;

  ProductModel({
    required this.id,
    required this.price,
    required this.adTitle,
    required this.description,
    required this.images,
    required this.modelName,
    required this.productName,
    required this.category,
    required this.user,
  });

  /*factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['_id'],
      price: List<String>.from(json['price'] ?? []),
      adTitle: List<String>.from(json['adTitle'] ?? []),
      description: List<String>.from(json['description'] ?? []),
      images: List<String>.from(json['images'] ?? []),
      modelName: json['modelName'] ?? '',
      productName: json['productName'] ?? '',
      category: json['categories'] ?? '',
      address1: List<String>.from(json['address1'] ?? []),
      address2: List<String>.from(json['address2'] ?? []),
      address3: List<String>.from(json['address3'] ?? []),
      user: json['userId'] != null && json['userId'] is Map
          ? UserModel.fromJson(json['userId'])
          : null,
    );
  }*/
}
