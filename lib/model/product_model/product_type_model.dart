class ProductTypeModel {
  String id;
  String name;
  String modelName;
  int count;
  CategoryCount categoryCounts;

  ProductTypeModel({
    required this.id,
    required this.name,
    required this.modelName,
    required this.count,
    required this.categoryCounts,
  });

  factory ProductTypeModel.fromJson(Map<String, dynamic> data) {
    return ProductTypeModel(
      id: data['_id'] ?? '',
      name: data['name'] ?? '',
      modelName: data['modelName'] ?? '',
      count: data['count'] ?? 0,
      categoryCounts: CategoryCount.fromJson(data['categories'] ?? {}),
    );
  }
}



class CategoryCount{
  int countForA;
  int countForB;
  int countForC;
  int countForD;
  int countForE;

  CategoryCount({
    required this.countForA,
    required this.countForB,
    required this.countForC,
    required this.countForD,
    required this.countForE,
  });

  factory CategoryCount.fromJson(Map<String, dynamic> data) {
    return CategoryCount(
      countForA: data['A'] ?? 0,
      countForB: data['B'] ?? 0,
      countForC: data['C'] ?? 0,
      countForD: data['D'] ?? 0,
      countForE: data['E'] ?? 0,
    );
  }
}

