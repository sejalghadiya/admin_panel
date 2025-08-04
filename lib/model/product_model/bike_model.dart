/*
class Bike{
  String id;
  String brand;
  String year;
  String price;
  String kmDriven;
  String adTitle;
  String description;
  String productType;
  String subProductType;
  String productName;
  String subProductName;

  Bike({
    required this.id,
    required this.brand,
    required this.year,
    required this.price,
    required this.kmDriven,
    required this.adTitle,
    required this.description,
    required this.productType,
    required this.subProductType,
    required this.productName,
    required this.subProductName

});

  factory Bike.fromJson(Map<String,dynamic>data){
    return Bike(
        id: data['_id'],
        brand: data['brand'],
        year: data['year'],
        price: data['price'],
        kmDriven: data['kmDriven'],
        adTitle: data['adTitle'], 
        description: data['description'],
        productType: data['productType']['_id'],
        subProductType: data['subProductType']['_id'],
        productName: data['productType']['name'],
        subProductName: data['subProductType']['name']
    );
  }
}*/

/*
class Bike  {
  String id;
  List<String> brand;
  List<String> year;
  List<String> price;
  List<String> kmDriven;
  List<String> adTitle;
  List<String> description;
  List<String> images;
  String productType;
  String subProductType;
  String productName;
  String subProductName;

  Bike({
    required this.id,
    required this.brand,
    required this.year,
    required this.price,
    required this.kmDriven,
    required this.adTitle,
    required this.description,
    required this.images,
    required this.productType,
    required this.subProductType,
    required this.productName,
    required this.subProductName,
  });

  factory Bike.fromJson(Map<String, dynamic> data) {
    return Bike(
      id: data['_id'] ?? '',
      brand: List<String>.from(data['brand'] ?? []),
      year: List<String>.from(data['year'] ?? []),
      price: List<String>.from(data['price'] ?? []),
      kmDriven: List<String>.from(data['kmDriven'] ?? []),
      adTitle: List<String>.from(data['adTitle'] ?? []),
      description: List<String>.from(data['description'] ?? []),
      images: List<String>.from(data['images'] ?? []),
      productType: data['productType']?['_id'] ?? '',
      subProductType: data['subProductType']?['_id'] ?? '',
      productName: data['productType']?['name'] ?? '',
      subProductName: data['subProductType']?['name'] ?? '',
    );
  }
}*/



import 'package:admin_panel/model/product_model/product.dart';

import '../user_model/user_model.dart';

class BikeModel extends ProductModel {
  @override
  List<dynamic> price;
  @override
  List<dynamic> adTitle;
  @override
  List<dynamic> description;
  @override
  List<dynamic> images;
  List<dynamic> brand;
  List<dynamic> year;
  List<dynamic> model;
  List<dynamic> kmDriven;
  @override
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
  UserModel user;
   String timestamps;
  bool isActive = true;
  bool isDeleted = false;
  BikeModel({
    required super.id,
    required this.price,
    required this.adTitle,
    required this.description,
    required this.images,
    required this.model,
    required this.brand,
    required this.year,
    required this.kmDriven,
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

  }) : super(
    price: price,
    adTitle: adTitle,
    description: description,
    images: images,
    modelName: modelName,
    productName: productName,
    category: category,
    user: user,
  );

  factory BikeModel.fromJson(Map<String, dynamic> json) {
    print(json['userId']);
    try {
      return BikeModel(
        // json['fName'] is List ? json['fName'].length > 0
        //     ? json['fName'][json['fName'].length - 1] : '':'',
        id: json['_id'] ?? '',
        price: json['price'],
        model: json['model'],
        adTitle: json['adTitle'],
        description: json['description'],
        images: json['images'] is List ? json['images'] : [],
        brand: json['brand'],
        year: json['year'],
        kmDriven: json['kmDriven'],
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
    }catch(e,stackTrace){
      print("Error in BikeModel.fromJson: $e");
      print("StackTrace: $stackTrace");
      rethrow;
    }
  }
}
