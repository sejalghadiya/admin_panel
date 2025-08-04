class UserTabModel {
  String category;
  int count;

  UserTabModel({
    required this.category,
    required this.count,
  });

  factory UserTabModel.fromJson(Map<String, dynamic> json) {
    return UserTabModel(
      category: json['category'] ?? '',
      count: json['count'] ?? 0,
    );
  }
}