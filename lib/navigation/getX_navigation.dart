import 'package:get/get.dart';

class GetxNavigation {
  /// next page
  static Future<void> next(String routeName, {dynamic arguments}) async {
    await Get.toNamed(routeName, arguments: arguments);
  }

  /// go back
  static void goBack() {
    Get.back();
  }

  /// go to the next page and remove the previous page
  static Future<void> navigateToNextAndRemovePrevious(String routeName,
      {dynamic arguments}) async {
    Get.offNamed(routeName, arguments: arguments);
  }

  /// go to the next page and remove all previous pages
  static Future<void> navigateToNextAndRemovePreviousAll(String routeName,
      {dynamic arguments}) async {
    Get.offAllNamed(routeName, arguments: arguments);
  }
}
