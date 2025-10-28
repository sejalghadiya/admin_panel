class AboutUsModel {
  final String id;
  String ourMission;
  String ourStory;
  int happyCustomer;
  int products;
  int satisfaction;
  List<OurValueModel> ourValues;
  String name;
  String tagLine;
  final String createdAt;
  final String updatedAt;

  AboutUsModel({
    required this.id,
    required this.ourMission,
    required this.ourStory,
    required this.happyCustomer,
    required this.products,
    required this.satisfaction,
    required this.ourValues,
    required this.name,
    required this.tagLine,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AboutUsModel.fromJson(Map<String, dynamic> json) {
    List<OurValueModel> values = [];
    if (json['our_values'] != null) {
      values = List<OurValueModel>.from(
        json['our_values'].map((value) => OurValueModel.fromJson(value)),
      );
    }

    return AboutUsModel(
      id: json['_id'] ?? '',
      ourMission: json['our_mission'] ?? '',
      ourStory: json['our_story'] ?? '',
      happyCustomer: json['happy_customer'] ?? 0,
      products: json['products'] ?? 0,
      satisfaction: json['statisfaction'] ?? 0, // Note the typo in the API response
      ourValues: values,
      name: json['name'] ?? '',
      tagLine: json['tag_line'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'our_mission': ourMission,
      'our_story': ourStory,
      'happy_customer': happyCustomer,
      'products': products,
      'statisfaction': satisfaction, // Using the same field name as in the API
      'our_values': ourValues.map((value) => value.toJson()).toList(),
      'name': name,
      'tag_line': tagLine,
    };
  }
}

class OurValueModel {
  final String id;
  String icon;
  String title;
  String description;

  OurValueModel({
    required this.id,
    required this.icon,
    required this.title,
    required this.description,
  });

  factory OurValueModel.fromJson(Map<String, dynamic> json) {
    return OurValueModel(
      id: json['_id'] ?? '',
      icon: json['icon'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'icon': icon,
      'title': title,
      'description': description,
    };
  }
}

