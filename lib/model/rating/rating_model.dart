class RatingModel {
  String id;
  double rating;
  UserModel user;
  String createdAt;
  String updatedAt;

  RatingModel({
    required this.id,
    required this.rating,
    required this.user,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(
      id: json['_id'] as String,
      rating: (json['rating'] as num).toDouble(),
      user: UserModel.fromJson(json['user']),
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'rating': rating,
      'user': user.toJson(),
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  @override
  String toString() {
    return 'RatingModel{id: $id, rating: $rating, user: $user}';
  }
}

class UserModel {
  String id;
  String fName;
  String lName;
  String mName;
  String email;
  String? profileImage;

  UserModel({
    required this.id,
    required this.fName,
    required this.lName,
    required this.mName,
    required this.email,
    this.profileImage,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] as String,
      fName: json['fName'] as String,
      lName: json['lName'] as String,
      mName: json['mName'] as String,
      email: json['email'] as String,
      profileImage: json['profileImage'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'fName': fName,
      'lName': lName,
      'mName': mName,
      'email': email,
      'profileImage': profileImage,
    };
  }

  String get fullName => '$fName $mName $lName'.trim();
}
