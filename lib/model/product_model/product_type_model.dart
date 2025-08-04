class ProductTypeModel {
  String id;
  String name;
  String modelName;
  int count;

  ProductTypeModel({
    required this.id,
    required this.name,
    required this.modelName,
    required this.count,
  });

  factory ProductTypeModel.fromJson(Map<String, dynamic> data) {
    return ProductTypeModel(
      id: data['_id'] ?? '',
      name: data['name'] ?? '',
      modelName: data['modelName'] ?? '',
      count: data['count'] ?? 0,
    );
  }
}

// class ProductTypeModel {
//   final String name;
//   final String modelName;
//
//   ProductTypeModel({required this.name, required this.modelName});
//
//   factory ProductTypeModel.fromJson(Map<String, dynamic> json) {
//     return ProductTypeModel(
//       name: json['name'],
//       modelName: json['modelName'],
//     );
//   }
//
//   // Override the toString method to return the name and modelName
//   @override
//   String toString() {
//     return 'ProductTypeModel(name: $name, modelName: $modelName)';
//   }
// }

