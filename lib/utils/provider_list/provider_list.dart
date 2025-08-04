
import 'package:admin_panel/provider/access_code_provider/access_code_provider.dart';
import 'package:admin_panel/provider/admin_login_provider/admin_login_provider.dart';
import 'package:admin_panel/provider/product_provider/product_provider.dart';
import 'package:admin_panel/provider/report_provider/report_provider.dart';
import 'package:admin_panel/provider/tab_provider/tab_provider.dart';
import 'package:admin_panel/provider/user_provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../provider/dashboard_provider/total_user_provider.dart';

class ProviderList {
  static  List<SingleChildWidget> providers = [
  //  ChangeNotifierProvider(create: (_) => DummyProvider()),

    ChangeNotifierProvider(create: (_) => AdminLoginProvider()),
    ChangeNotifierProvider(create: (_) => ProductProvider()),
    ChangeNotifierProvider(create: (_) => UserProvider()),
    ChangeNotifierProvider(create: (_) => TotalUserProvider()),
    ChangeNotifierProvider(create: (_) => AccessCodeProvider()),
    ChangeNotifierProvider(create: (_) => ReportProvider()),
    ChangeNotifierProvider(create: (_) => TabProvider()),

  ];
}