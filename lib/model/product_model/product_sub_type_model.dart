class ProductSubType {
  String id;
  String name;
  String productTypeId;
  String productTypeName;
  String modelName;

  ProductSubType({
    required this.id,
    required this.name,
    required this.productTypeId,
    required this.productTypeName,
    required this.modelName,
  });

  factory ProductSubType.fromJson(Map<String, dynamic> data) {
    return ProductSubType(
      id: data['_id'],
      name: data['name'],
      productTypeId: data['productType']['_id'],
      productTypeName: data['productType']['name'],
      modelName: data['productType']['modelName'],
    );
  }
}
