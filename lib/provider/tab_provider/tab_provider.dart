import 'package:admin_panel/app_version/app_version.dart';
import 'package:admin_panel/feature_request/feature_request_screen.dart';
import 'package:admin_panel/screens/rating.dart';
import 'package:flutter/material.dart';

import '../../access_code/access_code.dart';
import '../../dashboard.dart';
import '../../product/all_product_get.dart';
import '../../report/report_screen.dart';
import '../../user/user_Screen.dart';

class TabProvider with ChangeNotifier {
  int selectedIndex = 0;
  int lastIndex = 0;
  Widget selectedWidget = Dashboard();

  void setSelectedIndex(int index) {
    lastIndex = selectedIndex;
    selectedIndex = index;

    switch(index) {
      case 0: selectedWidget = Dashboard(); break;
      case 1: selectedWidget = AllProductGet(); break;
      case 2: selectedWidget = UserScreen(); break;
      case 3: selectedWidget = AccessCode(); break;
      case 4: selectedWidget = ReportScreen(); break;
      case 5: selectedWidget = AppVersion(); break;
      case 6: selectedWidget = FeatureRequestScreen(); break;
      case 7: selectedWidget = Rating(); break;
      case 8: selectedWidget = Center(child: Text("Chat Under Development"),); break;
      default: selectedWidget = Dashboard();
    }

    notifyListeners();
  }
}