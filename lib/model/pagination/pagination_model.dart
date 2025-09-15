class PaginationModel {
  final int totalItems;
  final int currentPage;
  final int totalPages;
  final int pageSize;
  final bool hasNextPage;
  final bool hasPrevPage;

  PaginationModel({
    required this.totalItems,
    required this.currentPage,
    required this.totalPages,
    required this.pageSize,
    required this.hasNextPage,
    required this.hasPrevPage,
  });

  factory PaginationModel.fromJson(Map<String, dynamic> json) {
    return PaginationModel(
      totalItems: json['totalItems'] as int,
      currentPage: json['currentPage'] as int,
      totalPages: json['totalPages'] as int,
      pageSize: json['pageSize'] as int,
      hasNextPage: json['hasNextPage'] as bool,
      hasPrevPage: json['hasPrevPage'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalItems': totalItems,
      'currentPage': currentPage,
      'totalPages': totalPages,
      'pageSize': pageSize,
      'hasNextPage': hasNextPage,
      'hasPrevPage': hasPrevPage,
    };
  }
}
