import '../user_model/user_model.dart';

class ReportModel {
  UserModel userModel;
  String id;
  String modelName;
  String description;
  String image;
  String productId;
  String createdAt;

  //changes
  String userId;
  String userName;
  String userMName;
  String userLName;
  String userEmail;
  String userGender;
  String userDOB;
  String userOccupation;
  String userPhone;
  String userStreet1;
  String userStreet2;
  String userArea;
  String userDistrict;
  String userState;
  String userPinCode;
  String userAadhaarNumber;

  //  String userDOB;
  //  String userOccupation;
  //  String userPhone;

  String productTitle;
  String productDescription;
  String productPrice;
  String productCategory;
  String productAddress;

  String productUserFName;
  String productUserLName;
  String productUserPhone;
  String productUserEmail;
  String productUserPinCode;
  String productUserState;
  String productUserDistrict;
  String productUserArea;
  String productUserCategory;
  String productUserDOB;
  String productUserOccupation;
  String productUserAadhaarNumber;
  bool isActive = true;

  // final String productUserEmail;

  ReportModel({
    required this.userAadhaarNumber,
    required this.userDOB,
    required this.userGender,
    required this.userMName,
    required this.userOccupation,
    required this.userPhone,
    required this.userPinCode,
    required this.userStreet1,
    required this.userStreet2,
    required this.userModel,
    required this.id,
    required this.userId,
    required this.modelName,
    required this.description,
    required this.image,
    required this.productId,
    required this.createdAt,
    required this.userName,
    required this.userEmail,
    required this.userState,
    required this.userDistrict,
    required this.userArea,
    required this.productTitle,
    required this.productDescription,
    required this.productPrice,
    required this.productCategory,
    required this.productAddress,
    required this.productUserFName,
    required this.productUserLName,
    required this.productUserPhone,
    required this.productUserPinCode,
    required this.productUserCategory,
    required this.productUserDOB,
    required this.productUserOccupation,
    required this.productUserAadhaarNumber,
    required this.productUserEmail,
    required this.productUserState,
    required this.productUserDistrict,
    required this.productUserArea,
    required this.isActive,
    required this.userLName,
    // required this.userPhone,
    // required this.userDOB,
    // required this.userOccupation,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    final user = json['userId'] ?? {};
    final product = json['productId'] ?? {};

    return ReportModel(
      userModel: UserModel.fromJson(user),
      id: json['_id'] ?? '',
      userId: json['userId']['_id'] ?? '',
      productId: product['_id'] ?? '',
      modelName: json['modelName'] ?? '',
      description: json['desctiption'] ?? '',
      image: json['image'] ?? '',
      createdAt: json['createdAt'] ?? '',
      userName: getLastIndexOfData(user['fName'] ?? []),
      userEmail: user['email'] ?? '',
      userLName: getLastIndexOfData(user['LName'] ?? []),
      // userDOB: getLastIndexOfData(user['DOB'] ?? []),
      // userOccupation: getLastIndexOfData(user['occupation'] ?? []),
      // userPhone: getLastIndexOfData(user['phone'] ?? []),
      productTitle: getLastIndexOfData(product['title'] ?? []),
      productDescription: getLastIndexOfData(product['description'] ?? []),
      productPrice: getLastIndexOfData(product['price'] ?? []),
      productCategory: product['categories'] ?? '',
      productAddress: getLastIndexOfData(product['address1'] ?? []),
      productUserFName: getLastIndexOfData(product['userId']['fName'] ?? []),
      productUserLName: getLastIndexOfData(product['userId']['LName'] ?? []),
      productUserPinCode: getLastIndexOfData(
        product['userId']['pinCode'] ?? [],
      ),
      productUserCategory: getLastIndexOfData(
        product['userId']['category'] ?? [],
      ),
      productUserDOB: getLastIndexOfData(product['userId']['DOB'] ?? []),
      productUserOccupation: getLastIndexOfData(
        product['userId']['occupation'] ?? [],
      ),
      productUserAadhaarNumber: getLastIndexOfData(
        product['userId']['aadhaarNumber'] ?? [],
      ),
      productUserPhone: getLastIndexOfData(product['userId']['phone'] ?? []),
      productUserEmail: product['userId']['email'] ?? '',
      productUserState: getLastIndexOfData(product['userId']['state'] ?? []),
      productUserDistrict: getLastIndexOfData(product['userId']['city'] ?? []),
      productUserArea: getLastIndexOfData(product['userId']['area'] ?? []),
      userState: getLastIndexOfData(user['state'] ?? []),
      userDistrict: getLastIndexOfData(user['city'] ?? []),
      userArea: getLastIndexOfData(user['area'] ?? []),
      isActive: json['isActive'] ?? true,
      userAadhaarNumber: '',
      userDOB: '',
      userGender: '',
      userMName: '',
      userOccupation: '',
      userPhone: '',
      userPinCode: '',
      userStreet1: '',
      userStreet2: '',
    );
  }

  static String getLastIndexOfData(List<dynamic> data) {
    if (data.isNotEmpty) {
      final lastIndex = data.length - 1;
      return data[lastIndex];
    }
    return '';
  }
}
