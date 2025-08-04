
import 'constants.dart';

class Apis {
  static const String BASE_URL = "https://api.bhavnika.shop/api";

  static const String ADMIN_LOGIN = "$BASE_URL/admin/login";
  static const String PRODUCT_TYPE = "$BASE_URL/admin/get_productS_Type";
  static const String GET_ALL_PRODUCTS = '$BASE_URL/admin/get_product_with_type';
  static String GET_PRODUCT_BY_ID(String productId, String modelName) => '$BASE_URL/admin/get-product-by-id?productId=$productId&model=$modelName';
  static const String UPDATE_PRODUCT = '$BASE_URL/admin/update_product_for_admin';
  static const String PRODUCT_IMAGE_DELETE_BY_USER = BASE_URL + Constants.PRODUCT_IMAGE_DELETE_BY_USER;
  static String GET_USER_BY_ID(String id) => BASE_URL+ Constants.GET_USER_BY_ID(id);
}