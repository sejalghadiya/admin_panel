class AppVersionModel {
  String id;
  String versionNumber;
  String versionName;
  DateTime releaseDate;
  String apkLink;
  String changes;
  bool isActive;

  AppVersionModel({
    required this.id,
    required this.versionNumber,
    required this.versionName,
    required this.releaseDate,
    required this.apkLink,
    required this.changes,
    required this.isActive,
  });

  factory AppVersionModel.fromJson(Map<String, dynamic> json) {
    return AppVersionModel(
      id: json['_id'] ?? '',
      versionNumber: json['version'] ?? "0.0",
      versionName: json['versionName'] ?? '',
      releaseDate: DateTime.parse(json['releaseDate'] ?? DateTime.now().toIso8601String()),
      apkLink: json['apkLink'] ?? '',
      changes: json['changes'] ?? '',
      isActive: json['isActive'] ?? true,
    );
  }

  // toJson method to convert the model to JSON format
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'version': versionNumber.toString(),
      'versionName': versionName,
      'releaseDate': releaseDate.toIso8601String(),
      'apkLink': apkLink,
      'changes': changes,
      'isActive': isActive,
    };
  }
}