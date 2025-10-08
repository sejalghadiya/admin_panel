import 'package:admin_panel/model/product_model/product.dart';
import '../user_model/user_model.dart';

class PropertyModel extends ProductModel {
  @override
  String id;
  String type;
  List<dynamic> bhk;
  List<dynamic> furnishing;
  List<dynamic> projectName;
  List<dynamic> projectStatus;
  List<dynamic> listedBy;
  List<String> area;
  List<dynamic> facing;
  @override
  List<dynamic> adTitle;
  @override
  List<dynamic> description;
  @override
  List<dynamic> price;
  DateTime createdTime;
  DateTime updatedTime;
  bool isDeleted;
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
  List<String> street1;
  List<String> street2;
  List<String> city;
  List<String> state;
  List<String> country;
  List<String> pincode;

  PropertyModel({
    required this.street1,
    required this.street2,
    required this.area,
    required this.city,
    required this.state,
    required this.country,
    required this.pincode,
    required this.id,
    required this.type,
    required this.bhk,
    required this.furnishing,
    required this.projectName,
    required this.projectStatus,
    required this.listedBy,
    required this.facing,
    required this.adTitle,
    required this.description,
    required this.createdTime,
    required this.updatedTime,
    required this.isDeleted,
    required this.images,
    required this.productType,
    required this.subProductType,
    required this.productName,
    required this.subProductName,
    required this.category,
    required this.modelName,
    required this.user,
    required this.price,
    required this.timestamps,
    required this.isActive,
  }): super(
    id: id,
    price: price,
    adTitle: adTitle,
    description: description,
    images: images,
    modelName: modelName,
    productName: productName,
    category: category,
    user: user,
  );

  factory PropertyModel.fromJson(Map<String, dynamic> json) {
    return PropertyModel(
      id: json['_id'] ?? '',
      type: json['type'] ?? '',
      price: json['price'],
      bhk: json['bhk'],
      furnishing: json['furnishing'],
      projectName: json['projectName'],
      projectStatus:json['projectStatus'],
      listedBy: json['listedBy'],
      facing: json['facing'],
      adTitle: json['adTitle'],
      description: json['description'],
      createdTime: DateTime.tryParse(json['createdTime'] ?? '') ?? DateTime.now(),
      updatedTime: DateTime.tryParse(json['updatedTime'] ?? '') ?? DateTime.now(),
      isDeleted: json['isDeleted'] ?? false,
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
