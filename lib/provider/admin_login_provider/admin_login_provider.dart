import 'dart:convert';

import 'package:admin_panel/home_page.dart';
import 'package:admin_panel/local_Storage/admin_shredPreferences.dart';
import 'package:admin_panel/navigation/getX_navigation.dart';
import 'package:admin_panel/network_connection/apis.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../../utils/toast_message/toast_message.dart';

class AdminLoginProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  final String _email = '';
  final String _password = '';

  String get email => _email;

  String get password => _password;

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  Future<void> adminLogin(Map<String, dynamic> body) async {
    setLoading(true);
    try {
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request('POST', Uri.parse(Apis.ADMIN_LOGIN));
      request.body = json.encode(body);
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      String responseBody = await response.stream.bytesToString();
      Map<String, dynamic> resJson = jsonDecode(responseBody);
      print(resJson);
      if (response.statusCode == 200) {
        String token = resJson['token'];
        print(token);
        AdminSharedPreferences().setAuthToken(token);
        GetxNavigation.navigateToNextAndRemovePreviousAll(HomeScreen.routeName);
        ToastMessage.success("Success", "Login Successful");
        setLoading(false);
      } else {
        String errorMessage = resJson['message'] ?? 'Login failed';
        ToastMessage.error("Error", errorMessage);
        setLoading(false);
      }
    }catch(e){
      print("Error: $e");
      ToastMessage.error("Error", "An error occurred. Please try again.");
      setLoading(false);
    }
  }
}
