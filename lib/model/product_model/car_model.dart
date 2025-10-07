
import 'package:admin_panel/model/product_model/product.dart';

import '../user_model/user_model.dart';

class CarModel  extends ProductModel {
  @override
  String id;
  List<dynamic> brand;
  List<dynamic> year;
  List<dynamic> fuel;
  List<dynamic> transmission;
  List<dynamic> kmDriven;
  List<dynamic> noOfOwners;
  List<dynamic> model;
  List<dynamic> title;
  @override
  List<dynamic> price;
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
  UserModel user;
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

  CarModel({
    required this.street1,
    required this.street2,
    required this.area,
    required this.city,
    required this.state,
    required this.country,
    required this.pincode,
    required this.id,
    required this.brand,
    required this.year,
    required this.fuel,
    required this.transmission,
    required this.kmDriven,
    required this.noOfOwners,
    required this.model,
    required this.title,
    required this.price,
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
  })  : super(
    id: id,
    price: price,
    adTitle: title,
    description: description,
    images: images,
    modelName: modelName,
    productName: productName,
    category: category,
    user: user,
  );

  factory CarModel.fromJson(Map<String, dynamic> json) {
    return CarModel(
      isActive: json['isActive'] ?? true,
      id: json['_id'] ?? '',
      brand:  json['brand'],
      year:  json['year'],
      fuel:  json['fuel'],
      transmission:  json['transmission'],
      kmDriven:  json['kmDriven'],
      noOfOwners: json['noOfOwners'],
      model:  json['model'],
      title:  json['title'],
      price:  json['price'],
      description:  json['description'],
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
