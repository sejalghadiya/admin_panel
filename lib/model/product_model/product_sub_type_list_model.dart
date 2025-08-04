class ProductSubTypeListModel {
  String id;
  String name;

  ProductSubTypeListModel({required this.id, required this.name});
  factory ProductSubTypeListModel.fromJson(Map<String, dynamic> data) {
    return ProductSubTypeListModel(
      id: data['_id'],
      name: data['name'],
    );
  }
}
