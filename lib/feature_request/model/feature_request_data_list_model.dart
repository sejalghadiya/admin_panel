enum FeatureRequestStatus { pending, accepted, declined }
class FeatureRequestDataListModel {
  final bool success;
  final List<FeatureRequestData> data;
  FeatureRequestDataListModel({
    required this.success,
    required this.data,
  });

  factory FeatureRequestDataListModel.fromJson(Map<String, dynamic> json) {
    return FeatureRequestDataListModel(
      success: json['success'] ?? false,
      data: json['data'] != null
          ? List<FeatureRequestData>.from(
              json['data'].map((x) => FeatureRequestData.fromJson(x)))
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data.map((x) => x.toJson()).toList(),
    };
  }
}

class FeatureRequestData {
  final String id;
  final String title;
  final String description;
  final UserData userId;
  final DateTime createdAt;
  final DateTime updatedAt;
  // enum string value for status : ["pending", "accepted", "declined"]
  String status = FeatureRequestStatus.pending.name;
  final String statusMessage;

  FeatureRequestData({
    required this.id,
    required this.title,
    required this.description,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
    required this.statusMessage,
  });

  factory FeatureRequestData.fromJson(Map<String, dynamic> json) {
    return FeatureRequestData(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      userId: UserData.fromJson(json['userId'] ?? {}),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
      status: json['status'] ?? FeatureRequestStatus.pending.name,
      statusMessage: json['statusMessage'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'userId': userId.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'status': status,
      'statusMessage': statusMessage,
    };
  }
}

class UserData {
  final String id;
  final String firstName;
  final String lastName;
  final String middleName;
  final String email;
  final String profileImage;

  UserData({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.middleName,
    required this.email,
    required this.profileImage,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['_id'] ?? '',
      firstName: json['fName'] ?? '',
      lastName: json['lName'] ?? '',
      middleName: json['mName'] ?? '',
      email: json['email'] ?? '',
      profileImage: json['profileImage'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'fName': firstName,
      'lName': lastName,
      'mName': middleName,
      'email': email,
      'profileImage': profileImage,
    };
  }
}