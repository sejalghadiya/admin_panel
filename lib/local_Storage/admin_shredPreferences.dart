import 'package:admin_panel/admin_auth/login_page.dart';
import 'package:admin_panel/navigation/getX_navigation.dart';
import 'package:admin_panel/utils/toast_message/toast_message.dart';
import 'package:shared_preferences/shared_preferences.dart';
/// -d chrome --web-port=8080 --web-experimental-hot-reload
class AdminSharedPreferences {
  Future<void> setMode(bool isDark) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("isDarkMode", isDark);
  }

  static Future<bool> getMode() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isDarkMode') ?? false;
  }
  Future<void> setAuthToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('authToken', token);
  }
  Future<String> getAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('authToken') ?? '';
  }

  Future<void> setUserId(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', userId);
  }
  Future<String> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId') ?? '';
  }

  Future<void> setUserProfileImage(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('profileImage', value);
  }
  Future<String> getUserProfileImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('profileImage') ?? '';
  }
  Future<void> setUserAadhaarFrontImage(String value) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('aadhaarCardImage1', value);
  }
  Future<String> getUserAadhaarFrontImage() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('aadhaarCardImage1') ?? '';
  }
  Future<void> setUserAadhaarBackImage(String value) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('aadhaarCardImage2', value);
  }
  Future<String> getUserAadhaarBackImage() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('aadhaarCardImage2') ?? '';
  }
  Future<void> setUserFirstName(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('fName', value);
  }
  Future<String> getUserFirstName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('fName') ?? '';
  }
  Future<void> setUserMiddleName(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('mName', value);
  }
  Future<String> getUserMiddleName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('mName') ?? '';
  }
  Future<void> setUserLastName(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('lName', value);
  }
  Future<String> getUserLastName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('lName') ?? '';
  }
  Future<void> setUserEmail(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', value);
  }
  Future<String> getUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('email') ?? '';
  }
  Future<void> setUserPhone(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('phone', value);
  }
  Future<String> getUserPhone() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('phone') ?? '';
  }
  Future<void> setUserDOB(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('DOB', value);
  }
  Future<String> getUserDOB() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('DOB') ?? '';
  }

  Future<void> setUserState(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('state', value);
  }
  Future<String> getUserState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('state') ?? '';
  }
  Future<void> setUserDistrict(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('district', value);
  }
  Future<String> getUserDistrict() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('district') ?? '';
  }
  Future<void> setUserArea(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('area', value);
  }
  Future<String> getUserArea() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('area') ?? '';
  }

  Future<void> setUserCategory(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userCategory', value);
  }
  Future<String> getUserCategory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userCategory') ?? '';
  }
  Future<void> setUserAadhaarNumber(String value) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('aadharNumber', value);
  }

  Future<String> getUserAadhaarNumber() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('aadharNumber') ?? '';
  }

  Future<void> setUserOccupation(String value) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('occupationId', value);
  }

  Future<String> getUserOccupationId() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('occupationId') ?? '';
  }

  // Outside the class
  Future<void> setUserReadList(List<String> value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('read', value);
  }

  Future<List<String>> getUserReadList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('read') ?? [];
  }

  Future<void> setUserWriteList(List<String> value) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('write', value);
  }
  Future<List<String>> getUserWriteList() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('write') ?? [];
  }

  Future<void> setUserCategoryId(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userCategory', value);
  }
  Future<String> getUserCategoryId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userCategory') ?? '';
  }

  Future<void> logout({String message=""}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    if(message.isEmpty){
      GetxNavigation.navigateToNextAndRemovePreviousAll(AdminLoginScreen.routeName);
      return;
    }
    GetxNavigation.navigateToNextAndRemovePreviousAll(AdminLoginScreen.routeName);
    ToastMessage.error("Error", "Session Expired");
  }
}