class AccessCodeModel {
  String id;
  String code;
  int useCount;
  int maxUseCount;
  String createdAt;
  String updatedAt;

  AccessCodeModel({
    required this.id,
    required this.code,
    required this.useCount,
    required this.maxUseCount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AccessCodeModel.fromJson(Map<String, dynamic> json) {
    return AccessCodeModel(
      id: json['_id'] ?? '',
      code: json['code'] ?? '',
      useCount: json['use_count'] ?? 0,
      maxUseCount: json['max_count'] ?? 0,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }
}