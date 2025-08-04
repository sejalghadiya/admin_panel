import 'package:admin_panel/model/product_model/product.dart';
import '../user_model/user_model.dart';

class JobModel extends ProductModel {
  @override
  String id;
  String serviceJob;
  List<dynamic> salaryPeriod;
  List<dynamic> positionType;
  List<dynamic> salaryFrom;
  List<dynamic> salaryTo;
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
  JobModel({
    required this.id,
    required this.serviceJob,
    required this.salaryPeriod,
    required this.positionType,
    required this.salaryFrom,
    required this.salaryTo,
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
  }): super(
    id: id,
    price: [],
    adTitle: adTitle,
    description: description,
    images: images,
    modelName: modelName,
    productName: productName,
    category: category,
    user: user,
  );

  factory JobModel.fromJson(Map<String, dynamic> json) {
    return JobModel(
      id: json['_id'] ?? '',
      serviceJob: json['service_job'] ?? '',
      salaryPeriod: json['salaryPeriod'],
      positionType: json['positionType'],
      salaryFrom: json['salaryFrom'],
      salaryTo: json['salaryTo'],
      adTitle: json['adTitle'],
      description: json['description'],
      images:json['images'] is List ? json['images'] : [],
      productType: json['productType']?['_id'] ?? '',
      subProductType: json['subProductType']?['_id'] ?? '',
      productName: json['productType']?['name'] ?? '',
      subProductName: json['subProductType']?['name'] ?? '',
      category: json['categories'] ?? '',
      modelName: json['productType']?['modelName'] ?? '',
      user: UserModel.fromJson(json['userId']),
      timestamps: json['createdAt'] ?? '',
      isActive: json['isActive'] ?? true,
      isDeleted: json['isDeleted'] ?? false,

    );
  }
}
