
import 'package:admin_panel/admin_auth/login_page.dart';
import 'package:admin_panel/home_page.dart';
import 'package:admin_panel/local_Storage/admin_shredPreferences.dart';
import 'package:admin_panel/navigation/getX_navigation.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = '/splash-screen';
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nextScreen();
  }

  Future<void> nextScreen() async {
    String token = await AdminSharedPreferences().getAuthToken();
    if(token.isNotEmpty) {
      GetxNavigation.next(HomeScreen.routeName);
    } else {
      GetxNavigation.next(AdminLoginScreen.routeName);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(100),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.green,
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Center(
          child: Text("Welcome to the App!"),
        ),
      ),
    );
  }
}
