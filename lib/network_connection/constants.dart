import 'apis.dart';

class Constants {
  static const String ADMIN_LOGIN = "/admin/login";
  static const String PRODUCT_TYPE = '/admin/get_productS_Type';
  static const String GET_ALL_PRODUCTS = '/admin/get_product_with_type';
  static String GET_PRODUCT_BY_ID(String productId,String modelName) => '/products/get-product-by-id?productId=$productId&model=$modelName';
  static const String PRODUCT_UPDATE_ = "/admin/update_product_for_admin";
  static const String PRODUCT_IMAGE_DELETE_BY_USER = "/products/delete-product-image";
  static String GET_USER_BY_ID(String id) => '/admin/getUserByID?userId=$id';
  static const String GET_ALL_RATINGS = '/admin/get-all-ratings';

  static const IMAGE_URL = '';
  static const GET_FEATURE_REQUEST = '/feature-request/admin/list';
  static  UPDATE_FEATURE_REQUEST_STATUS(String featureRequestId) => '/feature-request/admin/status/$featureRequestId';
}

class Url {
  // static const String baseUrl = Apis.BASE_URL_IMAGE;
  // static const String baseUrl = 'https://localhost:3001';

}