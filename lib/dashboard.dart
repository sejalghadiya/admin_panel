import 'package:admin_panel/navigation/getX_navigation.dart';
import 'package:admin_panel/provider/dashboard_provider/total_user_provider.dart';
import 'package:admin_panel/provider/product_provider/product_provider.dart';
import 'package:admin_panel/provider/report_provider/report_provider.dart';
import 'package:admin_panel/provider/tab_provider/tab_provider.dart';
import 'package:admin_panel/provider/user_provider/user_provider.dart';
import 'package:admin_panel/report/report_screen.dart';
import 'package:admin_panel/user/user_Screen.dart';
import 'package:admin_panel/product/all_product_get.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  static const routeName = "/dashboard-screen";

  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    // Use WidgetsBinding to schedule the data fetch AFTER the current build cycle
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TotalUserProvider>(context, listen: false).userCount();
      Provider.of<ReportProvider>(context, listen: false).reportCount();
      // Provider.of<TotalUserProvider>(context, listen: false).getAllCategoryCounts();
    });
  }

  // Navigate to products screen with optional category filter
  void navigateToProductsScreen({String category = ""}) {
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    final tabProvider = Provider.of<TabProvider>(context, listen: false);

    // Set the selected category if provided
    if (category.isNotEmpty) {
      productProvider.setSelectedCategory(category);
    } else {
      productProvider.setSelectedCategory("");
    }

    // Change to products tab
    tabProvider.setSelectedIndex(1);
  }

  @override
  Widget build(BuildContext context) {
    TotalUserProvider provider = Provider.of<TotalUserProvider>(
      context,
      listen: true,
    );
    ReportProvider reportProvider = Provider.of<ReportProvider>(
      context,
      listen: true,
    );
    ProductProvider productProvider = Provider.of<ProductProvider>(
      context,
      listen: true,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Wrap(
          spacing: 15,
          children: [
            Wrap(
              children: [
                Card(
                  margin: const EdgeInsets.all(12),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Total users",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 20,
                          runSpacing: 20,
                          children: [
                            _buildInfoBox(
                              title: "Total Users",
                              count: provider.totalUser.toString(),
                              color: Colors.blue,
                              onTap: () {
                                UserProvider userProvider =
                                    Provider.of<UserProvider>(
                                      context,
                                      listen: false,
                                    );
                                TabProvider tabProvider =
                                    Provider.of<TabProvider>(
                                      context,
                                      listen: false,
                                    );
                                userProvider.setSelectedCategory("");
                                userProvider.getUser();
                                tabProvider.setSelectedIndex(2);
                              },
                            ),
                            _buildInfoBox(
                              title: "Verified Users",
                              count: provider.verifiedUser.toString(),
                              color: Colors.green,
                              onTap: () {},
                            ),
                            _buildInfoBox(
                              title: "Pending Users",
                              count: provider.pendingUser.toString(),
                              color: Colors.red,
                              onTap: () {
                                final userProvider = Provider.of<UserProvider>(context, listen: false);
                                final tabProvider = Provider.of<TabProvider>(context, listen: false);
                                userProvider.setSelectedCategory("");          // All tab
                                userProvider.setStatusFilter("Pending");       // Status filter
                                userProvider.getUser();                        // Apply filter
                                tabProvider.setSelectedIndex(2);               // Go to User tab
                              },

                            ),
                            _buildInfoBox(
                              title: "Disable Users",
                              count: provider.disableUser.toString(),
                              color: Colors.orange,
                              onTap: () {
                                final userProvider = Provider.of<UserProvider>(context, listen: false);
                                final tabProvider = Provider.of<TabProvider>(context, listen: false);
                                userProvider.setSelectedCategory("");          // All tab
                                userProvider.setStatusFilter("Disabled");       // Status filter
                                userProvider.getUser();                        // Apply filter
                                tabProvider.setSelectedIndex(2);
                              },
                            ),
                            _buildInfoBox(
                              title: "Deleted Users",
                              count: provider.deletedUser.toString(),
                              color: Colors.orange,
                              onTap: () {
                                final userProvider = Provider.of<UserProvider>(context, listen: false);
                                final tabProvider = Provider.of<TabProvider>(context, listen: false);
                                userProvider.setSelectedCategory("");          // All tab
                                userProvider.setStatusFilter("Deleted");       // Status filter
                                userProvider.getUser();                        // Apply filter
                                tabProvider.setSelectedIndex(2);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  margin: EdgeInsets.all(12),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Total Products",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Wrap(
                          spacing: 20,
                          runSpacing: 20,
                          children: [
                            _buildInfoBox(
                              title: "Total Products",
                              count: provider.totalProductCount.toString(),
                              color: Colors.blue,
                              onTap: () {
                                navigateToProductsScreen();
                              },
                            ),
                            _buildInfoBox(
                              title: "Category A Products",
                              count: provider.totalProductA.toString(),
                              color: Colors.blue,
                              onTap: () {
                                navigateToProductsScreen(category: "A");
                              },
                            ),
                            _buildInfoBox(
                              title: "Category B Products",
                              count: provider.totalProductB.toString(),
                              color: Colors.green,
                              onTap: () {
                                navigateToProductsScreen(category: "B");
                              },
                            ),
                            _buildInfoBox(
                              title: "Category C Products",
                              count: provider.totalProductC.toString(),
                              color: Colors.red,
                              onTap: () {
                                navigateToProductsScreen(category: "C");
                              },
                            ),
                            _buildInfoBox(
                              title: "Category D Products",
                              count: provider.totalProductD.toString(),
                              color: Colors.red,
                              onTap: () {
                                navigateToProductsScreen(category: "D");
                              },
                            ),
                            _buildInfoBox(
                              title: "Category E Products",
                              count: provider.totalProductE.toString(),
                              color: Colors.red,
                              onTap: () {
                                navigateToProductsScreen(category: "E");
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  margin: EdgeInsets.all(12),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Total Reports",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Wrap(
                          spacing: 20,
                          runSpacing: 20,
                          children: [
                            _buildInfoBox(
                              title: "Total Reports",
                              count: provider.totalReport.toString(),
                              color: Colors.blue,
                              onTap: () {

                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  margin: EdgeInsets.all(12),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "User categories A",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Wrap(
                          spacing: 20,
                          runSpacing: 20,
                          children: [
                            _buildInfoBox(
                              title: "Total Users ",
                              count: provider.totalUserA.toString(),
                              color: Colors.blue,
                              onTap: () {
                                UserProvider userProvider =
                                Provider.of<UserProvider>(
                                  context,
                                  listen: false,
                                );
                                TabProvider tabProvider =
                                Provider.of<TabProvider>(
                                  context,
                                  listen: false,
                                );
                                userProvider.setSelectedCategory("A");
                                userProvider.getUser();
                                tabProvider.setSelectedIndex(2);
                              },
                            ),
                            _buildInfoBox(
                              title: "Verified Users ",
                              count: provider.verifiedUserA.toString(),
                              color: Colors.green,
                              onTap: () {},
                            ),
                            _buildInfoBox(
                              title: "Pending Users",
                              count: provider.pendingUserA.toString(),
                              color: Colors.red,
                              onTap: () {
                                final userProvider = Provider.of<UserProvider>(context, listen: false);
                                final tabProvider = Provider.of<TabProvider>(context, listen: false);
                                userProvider.setSelectedCategory("A");          // All tab
                                userProvider.setStatusFilter("Pending");       // Status filter
                                userProvider.getUser();                        // Apply filter
                                tabProvider.setSelectedIndex(2);
                              },
                            ),
                            _buildInfoBox(
                              title: "Disable Users",
                              count: provider.disableUserA.toString(),
                              color: Colors.orange,
                              onTap: () {
                                final userProvider = Provider.of<UserProvider>(context, listen: false);
                                final tabProvider = Provider.of<TabProvider>(context, listen: false);
                                userProvider.setSelectedCategory("A");          // All tab
                                userProvider.setStatusFilter("Disabled");       // Status filter
                                userProvider.getUser();                        // Apply filter
                                tabProvider.setSelectedIndex(2);
                              },
                            ),
                            _buildInfoBox(
                              title: "Deleted Users ",
                              count: provider.deletedUserA.toString(),
                              color: Colors.blue,
                              onTap: () {
                                final userProvider = Provider.of<UserProvider>(context, listen: false);
                                final tabProvider = Provider.of<TabProvider>(context, listen: false);
                                userProvider.setSelectedCategory("A");          // All tab
                                userProvider.setStatusFilter("Deleted");       // Status filter
                                userProvider.getUser();                        // Apply filter
                                tabProvider.setSelectedIndex(2);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  margin: EdgeInsets.all(12),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "User categories B",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Wrap(
                          spacing: 20,
                          runSpacing: 20,
                          children: [
                            _buildInfoBox(
                              title: "Total Users ",
                              count: provider.totalUserB.toString(),
                              color: Colors.blue,
                              onTap: () {
                                UserProvider userProvider =
                                Provider.of<UserProvider>(
                                  context,
                                  listen: false,
                                );
                                TabProvider tabProvider =
                                Provider.of<TabProvider>(
                                  context,
                                  listen: false,
                                );
                                userProvider.setSelectedCategory("B");
                                userProvider.getUser();
                                tabProvider.setSelectedIndex(2);
                              },
                            ),
                            _buildInfoBox(
                              title: "Verified Users ",
                              count: provider.verifiedUserB.toString(),
                              color: Colors.green,
                              onTap: () {},
                            ),
                            _buildInfoBox(
                              title: "Pending Users",
                              count: provider.pendingUserB.toString(),
                              color: Colors.red,
                              onTap: () {
                                final userProvider = Provider.of<UserProvider>(context, listen: false);
                                final tabProvider = Provider.of<TabProvider>(context, listen: false);
                                userProvider.setSelectedCategory("B");          // All tab
                                userProvider.setStatusFilter("Pending");       // Status filter
                                userProvider.getUser();                        // Apply filter
                                tabProvider.setSelectedIndex(2);
                              },
                            ),
                            _buildInfoBox(
                              title: "Disable Users",
                              count: provider.disableUserB.toString(),
                              color: Colors.orange,
                              onTap: () {
                                final userProvider = Provider.of<UserProvider>(context, listen: false);
                                final tabProvider = Provider.of<TabProvider>(context, listen: false);
                                userProvider.setSelectedCategory("B");          // All tab
                                userProvider.setStatusFilter("Disabled");       // Status filter
                                userProvider.getUser();                        // Apply filter
                                tabProvider.setSelectedIndex(2);
                              },
                            ),
                            _buildInfoBox(
                              title: "Deleted Users ",
                              count: provider.deletedUserB.toString(),
                              color: Colors.blue,
                              onTap: () {
                                final userProvider = Provider.of<UserProvider>(context, listen: false);
                                final tabProvider = Provider.of<TabProvider>(context, listen: false);
                                userProvider.setSelectedCategory("B");          // All tab
                                userProvider.setStatusFilter("Deleted");       // Status filter
                                userProvider.getUser();                        // Apply filter
                                tabProvider.setSelectedIndex(2);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  margin: EdgeInsets.all(12),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "User categories α",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Wrap(
                          spacing: 20,
                          runSpacing: 20,
                          children: [
                            _buildInfoBox(
                              title: "Total Users ",
                              count: provider.totalUser1.toString(),
                              color: Colors.blue,
                              onTap: () {
                                UserProvider userProvider =
                                Provider.of<UserProvider>(
                                  context,
                                  listen: false,
                                );
                                TabProvider tabProvider =
                                Provider.of<TabProvider>(
                                  context,
                                  listen: false,
                                );
                                userProvider.setSelectedCategory("α");
                                userProvider.getUser();
                                tabProvider.setSelectedIndex(2);
                              },
                            ),
                            _buildInfoBox(
                              title: "Verified Users ",
                              count: provider.verifiedUser1.toString(),
                              color: Colors.green,
                              onTap: () {},
                            ),
                            _buildInfoBox(
                              title: "Pending Users",
                              count: provider.pendingUser1.toString(),
                              color: Colors.red,
                              onTap: () {
                                final userProvider = Provider.of<UserProvider>(context, listen: false);
                                final tabProvider = Provider.of<TabProvider>(context, listen: false);
                                userProvider.setSelectedCategory("α");          // All tab
                                userProvider.setStatusFilter("Pending");       // Status filter
                                userProvider.getUser();                        // Apply filter
                                tabProvider.setSelectedIndex(2);
                              },
                            ),
                            _buildInfoBox(
                              title: "Disable Users",
                              count: provider.disableUser1.toString(),
                              color: Colors.orange,
                              onTap: () {
                                final userProvider = Provider.of<UserProvider>(context, listen: false);
                                final tabProvider = Provider.of<TabProvider>(context, listen: false);
                                userProvider.setSelectedCategory("α");          // All tab
                                userProvider.setStatusFilter("Disabled");       // Status filter
                                userProvider.getUser();                        // Apply filter
                                tabProvider.setSelectedIndex(2);
                              },
                            ),
                            _buildInfoBox(
                              title: "Deleted Users ",
                              count: provider.deletedUser1.toString(),
                              color: Colors.blue,
                              onTap: () {
                                final userProvider = Provider.of<UserProvider>(context, listen: false);
                                final tabProvider = Provider.of<TabProvider>(context, listen: false);
                                userProvider.setSelectedCategory("α");          // All tab
                                userProvider.setStatusFilter("Deleted");       // Status filter
                                userProvider.getUser();                        // Apply filter
                                tabProvider.setSelectedIndex(2);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  margin: EdgeInsets.all(12),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "User categories β",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Wrap(
                          spacing: 20,
                          runSpacing: 20,
                          children: [
                            _buildInfoBox(
                              title: "Total Users ",
                              count: provider.totalUser2.toString(),
                              color: Colors.blue,
                              onTap: () {
                                UserProvider userProvider =
                                Provider.of<UserProvider>(
                                  context,
                                  listen: false,
                                );
                                TabProvider tabProvider =
                                Provider.of<TabProvider>(
                                  context,
                                  listen: false,
                                );
                                userProvider.setSelectedCategory("β");
                                userProvider.getUser();
                                tabProvider.setSelectedIndex(2);
                              },
                            ),
                            _buildInfoBox(
                              title: "Verified Users ",
                              count: provider.verifiedUser2.toString(),
                              color: Colors.green,
                              onTap: () {},
                            ),
                            _buildInfoBox(
                              title: "Pending Users",
                              count: provider.pendingUser2.toString(),
                              color: Colors.red,
                              onTap: () {
                                final userProvider = Provider.of<UserProvider>(context, listen: false);
                                final tabProvider = Provider.of<TabProvider>(context, listen: false);
                                userProvider.setSelectedCategory("β");          // All tab
                                userProvider.setStatusFilter("Pending");       // Status filter
                                userProvider.getUser();                        // Apply filter
                                tabProvider.setSelectedIndex(2);
                              },
                            ),
                            _buildInfoBox(
                              title: "Disable Users",
                              count: provider.disableUser2.toString(),
                              color: Colors.orange,
                              onTap: () {
                                final userProvider = Provider.of<UserProvider>(context, listen: false);
                                final tabProvider = Provider.of<TabProvider>(context, listen: false);
                                userProvider.setSelectedCategory("β");          // All tab
                                userProvider.setStatusFilter("Disabled");       // Status filter
                                userProvider.getUser();                        // Apply filter
                                tabProvider.setSelectedIndex(2);
                              },
                            ),
                            _buildInfoBox(
                              title: "Deleted Users ",
                              count: provider.deletedUser2.toString(),
                              color: Colors.blue,
                              onTap: () {
                                final userProvider = Provider.of<UserProvider>(context, listen: false);
                                final tabProvider = Provider.of<TabProvider>(context, listen: false);
                                userProvider.setSelectedCategory("β");          // All tab
                                userProvider.setStatusFilter("Deleted");       // Status filter
                                userProvider.getUser();                        // Apply filter
                                tabProvider.setSelectedIndex(2);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoBox({
    required String title,
    required String count,
    required Color color,
    required Function()? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: 100,
        height: 80,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color, width: 1.5),
          ),
          child: Column(
            children: [
              Text(
                count,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              SizedBox(height: 2),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: color),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
